<template>
  <div class="seat-select">
    <div class="header">
      <button class="back-btn" @click="$router.back()">← 返回</button>
      <h2>选择座位</h2>
    </div>
    
    <div v-if="seats.length === 0" class="loading">
      <p>加载中... (seats: {{ seats.length }}, sessionId: {{ $route.params.sessionId }}, hallId: {{ $route.params.hallId }})</p>
    </div>
    
    <template v-else>
      <div class="screen-area">
        <div class="screen">银幕</div>
      </div>
      
      <div class="seat-container">
        <div class="seat-row" v-for="(row, rowIndex) in seatRows" :key="rowIndex">
          <span class="row-label">{{ String.fromCharCode(65 + rowIndex) }}</span>
          <div class="seats">
            <div v-for="seat in row" :key="seat.id" 
                 class="seat" 
                 :class="getSeatClass(seat)"
                 @click="toggleSeat(seat)">
              <span class="seat-number">{{ seat.colNum }}</span>
            </div>
          </div>
        </div>
      </div>
      
      <div class="legend">
        <div class="legend-item">
          <span class="legend-seat available"></span>
          <span>可选</span>
        </div>
        <div class="legend-item">
          <span class="legend-seat selected"></span>
          <span>已选</span>
        </div>
        <div class="legend-item">
          <span class="legend-seat vip"></span>
          <span>VIP</span>
        </div>
        <div class="legend-item">
          <span class="legend-seat couple"></span>
          <span>情侣座</span>
        </div>
        <div class="legend-item">
          <span class="legend-seat unavailable"></span>
          <span>已售</span>
        </div>
      </div>
      
      <div class="info-panel">
        <div class="selected-info">
          <span>已选座位：</span>
          <span class="seats-list">{{ selectedSeatNos || '请选择座位' }}</span>
        </div>
        <div class="price-info">
          <span>总价：</span>
          <span class="price">¥{{ totalPrice }}</span>
        </div>
        <button class="confirm-btn" @click="confirmOrder" :disabled="selectedSeats.length === 0">
          确认购票
        </button>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { seatApi, orderApi, sessionApi } from '../api';

const route = useRoute();
const router = useRouter();
const seats = ref([]);
const selectedSeats = ref([]);
const price = ref(0);

const seatRows = computed(() => {
  const rows = {};
  seats.value.forEach(seat => {
    if (!rows[seat.rowNum]) rows[seat.rowNum] = [];
    rows[seat.rowNum].push(seat);
  });
  return Object.values(rows).map(row => row.sort((a, b) => a.colNum - b.colNum));
});

const selectedSeatNos = computed(() => {
  return seats.value
    .filter(s => selectedSeats.value.includes(s.id))
    .map(s => `${s.seatNo}`)
    .join(', ');
});

const totalPrice = computed(() => {
  let total = 0;
  seats.value.filter(s => selectedSeats.value.includes(s.id)).forEach(seat => {
    if (seat.type === 'VIP') total += price.value * 1.5;
    else if (seat.type === '情侣座') total += price.value * 2;
    else total += price.value;
  });
  return total || price.value * selectedSeats.value.length;
});

const getSeatClass = (seat) => {
  const isAvailable = isSeatAvailable(seat);
  const isSelected = selectedSeats.value.includes(seat.id);
  if (!isAvailable) return 'unavailable';
  if (isSelected) return 'selected';
  if (seat.type === 'VIP') return 'vip';
  if (seat.type === '情侣座') return 'couple';
  return 'available';
};

const toggleSeat = (seat) => {
  if (!isSeatAvailable(seat)) return;
  const index = selectedSeats.value.indexOf(seat.id);
  if (index > -1) selectedSeats.value.splice(index, 1);
  else selectedSeats.value.push(seat.id);
};

const isSeatAvailable = (seat) => {
  return seat.available === true || seat.available === 'true' || seat.available === 1 || seat.available === '1';
};

const loadSeats = async () => {
  try {
    const sessionId = route.params.sessionId;
    const hallId = route.params.hallId;
    console.log('Loading seats for hall:', hallId, 'session:', sessionId);
    
    const [sessionRes, seatsRes] = await Promise.all([
      sessionApi.getById(sessionId),
      seatApi.getAvailable(hallId, sessionId)
    ]);
    
    console.log('Session response:', sessionRes.status, sessionRes.data);
    console.log('Seats response:', seatsRes.status, 'count:', seatsRes.data?.length);
    
    price.value = sessionRes.data.price;
    seats.value = seatsRes.data || [];
    
    console.log('seats.value after assignment:', seats.value.length, 'seats');
    console.log('seatRows computed:', seatRows.value.length, 'rows');
  } catch (err) {
    console.error('加载失败', err);
    if (err.response) {
      console.error('Response status:', err.response.status);
      console.error('Response data:', err.response.data);
    }
  }
};

const confirmOrder = async () => {
  try {
    const userId = localStorage.getItem('userId') || 1;
    console.log('Creating order with:', { userId, sessionId: route.params.sessionId, seatIds: selectedSeats.value, totalPrice: totalPrice.value });
    
    const orderRes = await orderApi.create({
      userId: userId,
      sessionId: route.params.sessionId,
      seatIds: selectedSeats.value,
      totalPrice: totalPrice.value
    });
    console.log('Order created:', orderRes.data);
    
    await orderApi.confirm(orderRes.data.id);
    console.log('Order confirmed');
    
    router.push(`/order/${orderRes.data.orderNo}`);
  } catch (err) {
    console.error('下单失败', err);
    if (err.response) {
      console.error('Response:', err.response.data);
    }
  }
};

onMounted(loadSeats);
</script>

<style scoped>
.seat-select { padding: 20px; background: linear-gradient(180deg, #1a1a2e 0%, #16213e 100%); min-height: 100vh; color: #fff; }

.header { display: flex; align-items: center; gap: 20px; margin-bottom: 30px; }
.back-btn { background: transparent; border: 1px solid rgba(255,255,255,0.3); color: #fff; padding: 8px 16px; border-radius: 4px; cursor: pointer; }
.back-btn:hover { background: rgba(255,255,255,0.1); }
.header h2 { color: #fff; font-size: 20px; }

.screen-area { margin-bottom: 40px; }
.screen { width: 60%; height: 30px; margin: 0 auto; background: linear-gradient(180deg, transparent 0%, rgba(255,255,255,0.2) 100%); border-radius: 50% 50% 0 0 / 100% 100% 0 0; display: flex; align-items: center; justify-content: center; color: rgba(255,255,255,0.5); font-size: 14px; letter-spacing: 4px; }

.seat-container { display: flex; flex-direction: column; align-items: center; gap: 8px; margin-bottom: 30px; }
.seat-row { display: flex; align-items: center; gap: 10px; }
.row-label { width: 20px; color: rgba(255,255,255,0.5); font-size: 14px; }
.seats { display: flex; gap: 6px; }

.seat { width: 36px; height: 36px; border-radius: 8px 8px 4px 4px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; position: relative; }
.seat::before { content: ''; position: absolute; top: -4px; width: 80%; height: 6px; background: inherit; border-radius: 4px 4px 0 0; }

.seat.available { background: #2ecc71; }
.seat.available:hover { transform: scale(1.1); box-shadow: 0 0 10px #2ecc71; }

.seat.selected { background: #e74c3c; transform: scale(1.1); box-shadow: 0 0 15px #e74c3c; }
.seat.selected .seat-number { color: #fff; font-weight: bold; }

.seat.unavailable { background: #7f8c8d; cursor: not-allowed; opacity: 0.5; }

.seat.vip { background: #f39c12; }
.seat.vip:hover { transform: scale(1.1); box-shadow: 0 0 10px #f39c12; }

.seat.couple { background: #9b59b6; }
.seat.couple { width: 60px; }
.seat.couple:hover { transform: scale(1.05); box-shadow: 0 0 10px #9b59b6; }

.seat-number { font-size: 12px; color: rgba(0,0,0,0.6); font-weight: 500; }

.legend { display: flex; justify-content: center; gap: 30px; margin-bottom: 30px; flex-wrap: wrap; }
.legend-item { display: flex; align-items: center; gap: 8px; font-size: 13px; color: rgba(255,255,255,0.7); }
.legend-seat { width: 24px; height: 24px; border-radius: 6px 6px 3px 3px; }
.legend-seat.available { background: #2ecc71; }
.legend-seat.selected { background: #e74c3c; }
.legend-seat.vip { background: #f39c12; }
.legend-seat.couple { background: #9b59b6; width: 40px; }
.legend-seat.unavailable { background: #7f8c8d; }

.info-panel { background: #0f0f23; border-radius: 16px; padding: 20px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 15px; }
.selected-info, .price-info { display: flex; align-items: center; gap: 10px; color: rgba(255,255,255,0.7); }
.seats-list { color: #3498db; font-weight: 500; }
.price { color: #e74c3c; font-size: 24px; font-weight: bold; }
.confirm-btn { padding: 14px 40px; background: #e74c3c; color: #fff; border: none; border-radius: 8px; font-size: 16px; font-weight: 500; cursor: pointer; transition: all 0.2s; }
.confirm-btn:hover:not(:disabled) { background: #c0392b; transform: translateY(-2px); box-shadow: 0 4px 15px rgba(231,76,60,0.4); }
.confirm-btn:disabled { background: #7f8c8d; cursor: not-allowed; }
</style>