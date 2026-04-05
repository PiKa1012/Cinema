<template>
  <div class="my-orders-page">
    <div class="page-header">
      <h2>我的订单</h2>
    </div>

    <div class="orders-list" v-if="groupedOrders.length > 0">
      <div v-for="group in groupedOrders" :key="group.sessionId" class="session-group">
        <div class="session-header">
          <div class="session-info">
            <div class="movie-name">{{ group.movieTitle }}</div>
            <div class="session-detail">
              <span class="icon">🏢</span> {{ group.hallName }}
              <span class="divider">|</span>
              <span class="icon">🕐</span> {{ formatTime(group.startTime) }}
            </div>
          </div>
          <div class="session-total">
            <span class="label">共 {{ group.totalSeats }} 张票</span>
            <span class="price">¥{{ group.totalPrice }}</span>
          </div>
        </div>

        <div class="tickets-list">
          <div v-for="order in group.orders" :key="order.id" class="ticket-item">
            <div class="ticket-header">
              <span class="ticket-no">订单号：{{ order.orderNo }}</span>
              <span class="ticket-status" :class="order.status">{{ getStatusText(order.status) }}</span>
            </div>
            <div class="ticket-seats">
              <span v-for="seat in order.seats" :key="seat.id" class="seat-tag">{{ seat.seatNo }}</span>
            </div>
            <div class="ticket-footer">
              <span class="ticket-time">{{ formatTime(order.createTime) }}</span>
              <span class="ticket-price">¥{{ order.totalPrice }}</span>
            </div>
          </div>
        </div>

        <div class="toggle-seats" @click="toggleSeats(group.sessionId)">
          <span>{{ expandedSessions[group.sessionId] ? '收起座位图' : '查看座位图' }}</span>
          <span class="arrow" :class="{ open: expandedSessions[group.sessionId] }">▼</span>
        </div>

        <div class="session-seats" v-if="expandedSessions[group.sessionId] && sessionSeats[group.sessionId]">
          <div class="seat-admin">
            <div class="screen-area"><div class="screen">银幕</div></div>
            <div class="seat-grid">
              <div class="seat-row" v-for="(row, i) in sessionSeats[group.sessionId]" :key="i">
                <span class="row-label">{{ String.fromCharCode(65 + i) }}</span>
                <div class="seats">
                  <div v-for="seat in row" :key="seat.id" 
                       class="seat" 
                       :class="getOrderSeatClass(seat, group.bookedSeatIds)"
                       :title="seat.seatNo">
                  </div>
                </div>
              </div>
            </div>
            <div class="legend">
              <span class="legend-item"><span class="legend-seat available"></span> 普通</span>
              <span class="legend-item"><span class="legend-seat vip"></span> VIP</span>
              <span class="legend-item"><span class="legend-seat couple"></span> 情侣座</span>
              <span class="legend-item"><span class="legend-seat sold"></span> 已售</span>
              <span class="legend-item"><span class="legend-seat is-booked"></span> 我的座位</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="empty">
      <p>暂无订单</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { orderApi, seatApi } from '../api';

const orders = ref([]);
const sessionSeats = ref({});
const expandedSessions = ref({});
const userId = localStorage.getItem('userId');

const loadOrders = async () => {
  try {
    const res = await orderApi.getByUser(userId);
    orders.value = res.data;
    
    const sessionCache = {};
    for (const order of orders.value) {
      const sessionId = order.session?.id;
      const hallId = order.session?.hall?.id;
      if (sessionId && hallId && !sessionCache[sessionId]) {
        try {
          const seatsRes = await seatApi.getAvailable(hallId, sessionId);
          const allSeats = seatsRes.data || [];
          sessionCache[sessionId] = allSeats;
        } catch (e) {
          console.error(e);
        }
      }
    }
    
    for (const sessionId in sessionCache) {
      const allSeats = sessionCache[sessionId];
      const sessionOrders = orders.value.filter(o => o.session?.id == sessionId);
      const allBookedSeatIds = new Set();
      sessionOrders.forEach(o => {
        (o.seats || []).forEach(s => allBookedSeatIds.add(s.id));
      });
      
      const rows = {};
      allSeats.forEach(seat => {
        if (!rows[seat.rowNum]) rows[seat.rowNum] = [];
        rows[seat.rowNum].push({
          ...seat,
          isBooked: allBookedSeatIds.has(seat.id)
        });
      });
      sessionSeats.value[sessionId] = Object.values(rows).map(row => row.sort((a, b) => a.colNum - b.colNum));
    }
  } catch (e) {
    console.error(e);
  }
};

const groupedOrders = computed(() => {
  const groups = {};
  orders.value.forEach(order => {
    const sessionId = order.session?.id;
    if (!sessionId) return;
    
    if (!groups[sessionId]) {
      groups[sessionId] = {
        sessionId,
        movieTitle: order.session?.movie?.title || '',
        hallName: order.session?.hall?.name || '',
        startTime: order.session?.startTime,
        orders: [],
        bookedSeatIds: new Set(),
        totalSeats: 0,
        totalPrice: 0
      };
    }
    
    groups[sessionId].orders.push(order);
    (order.seats || []).forEach(s => {
      groups[sessionId].bookedSeatIds.add(s.id);
      groups[sessionId].totalSeats++;
    });
    groups[sessionId].totalPrice += parseFloat(order.totalPrice || 0);
  });
  
  return Object.values(groups).sort((a, b) => new Date(b.startTime) - new Date(a.startTime));
});

const getStatusText = (status) => {
  const map = { paid: '已支付', pending: '待支付', cancelled: '已取消', confirmed: '已确认' };
  return map[status] || status;
};

const formatTime = (time) => {
  if (!time) return '-';
  return new Date(time).toLocaleString('zh-CN');
};

const toggleSeats = (sessionId) => {
  expandedSessions.value[sessionId] = !expandedSessions.value[sessionId];
};

const getOrderSeatClass = (seat, bookedSeatIds) => {
  const classes = [];
  if (seat.isBooked) {
    if (seat.type === 'VIP') classes.push('vip');
    else if (seat.type === '情侣座') classes.push('couple');
    else classes.push('available');
    classes.push('is-booked');
  } else {
    if (seat.available === false) classes.push('sold');
    else if (seat.type === 'VIP') classes.push('vip');
    else if (seat.type === '情侣座') classes.push('couple');
    else classes.push('available');
  }
  return classes.join(' ');
};

onMounted(loadOrders);
</script>

<style scoped>
.my-orders-page {
  min-height: calc(100vh - 52px);
  background: #0f0f0f;
  padding: 40px 20px;
}

.page-header {
  max-width: 900px;
  margin: 0 auto 30px;
}

.page-header h2 {
  color: #fff;
  font-size: 24px;
  font-weight: 600;
}

.orders-list {
  max-width: 900px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.session-group {
  background: #1c1c1c;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0,0,0,0.4);
}

.session-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  border-bottom: 1px solid rgba(255,255,255,0.08);
}

.movie-name {
  color: #fff;
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 6px;
}

.session-detail {
  color: rgba(255,255,255,0.6);
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.session-detail .divider {
  color: rgba(255,255,255,0.2);
}

.session-total {
  text-align: right;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 4px;
}

.session-total .label {
  color: rgba(255,255,255,0.5);
  font-size: 13px;
}

.session-total .price {
  color: #e50914;
  font-size: 20px;
  font-weight: 700;
}

.tickets-list {
  padding: 16px 24px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.ticket-item {
  background: rgba(255,255,255,0.03);
  border: 1px solid rgba(255,255,255,0.06);
  border-radius: 10px;
  padding: 16px;
}

.ticket-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.ticket-no {
  color: rgba(255,255,255,0.4);
  font-size: 12px;
}

.ticket-status {
  font-size: 12px;
  padding: 3px 10px;
  border-radius: 4px;
}

.ticket-status.paid { background: rgba(76, 175, 80, 0.2); color: #4caf50; }
.ticket-status.pending { background: rgba(255, 152, 0, 0.2); color: #ff9800; }
.ticket-status.cancelled { background: rgba(158, 158, 158, 0.2); color: #9e9e9e; }
.ticket-status.confirmed { background: rgba(33, 150, 243, 0.2); color: #2196f3; }

.ticket-seats {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 10px;
}

.seat-tag {
  background: rgba(229, 9, 20, 0.15);
  color: #e50914;
  padding: 4px 12px;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 500;
}

.ticket-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.ticket-time {
  color: rgba(255,255,255,0.3);
  font-size: 12px;
}

.ticket-price {
  color: #fff;
  font-size: 15px;
  font-weight: 600;
}

.toggle-seats {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 8px;
  padding: 12px;
  color: rgba(255,255,255,0.5);
  font-size: 13px;
  cursor: pointer;
  transition: color 0.2s;
  border-top: 1px solid rgba(255,255,255,0.06);
}

.toggle-seats:hover {
  color: #e50914;
}

.toggle-seats .arrow {
  font-size: 10px;
  transition: transform 0.3s;
}

.toggle-seats .arrow.open {
  transform: rotate(180deg);
}

.session-seats {
  padding: 0 24px 20px;
}

.seat-admin { padding: 16px; background: #141414; border-radius: 12px; }
.screen-area { display: flex; justify-content: center; margin-bottom: 20px; }
.screen { width: 60%; height: 24px; background: rgba(255,255,255,0.08); border-radius: 50% 50% 0 0; display: flex; align-items: center; justify-content: center; color: rgba(255,255,255,0.3); font-size: 11px; letter-spacing: 4px; }
.seat-grid { display: flex; flex-direction: column; align-items: center; gap: 6px; margin-bottom: 16px; }
.seat-row { display: flex; align-items: center; gap: 6px; }
.row-label { width: 18px; color: rgba(255,255,255,0.4); font-size: 11px; }
.seats { display: flex; gap: 3px; }
.seat { width: 24px; height: 24px; border-radius: 5px 5px 3px 3px; transition: all 0.2s; }
.seat.normal { background: #4caf50; }
.seat.available { background: #4caf50; }
.seat.vip { background: #8e44ad; }
.seat.couple { background: #2980b9; width: 40px; }
.seat.sold { background: #2a2a2a; cursor: not-allowed; opacity: 0.5; }
.seat.is-booked { box-shadow: 0 0 10px 3px rgba(229, 9, 20, 0.8); border: 2px solid #e50914; z-index: 1; }
.legend { display: flex; justify-content: center; gap: 16px; flex-wrap: wrap; }
.legend-item { display: flex; align-items: center; gap: 5px; font-size: 12px; color: rgba(255,255,255,0.5); }
.legend-seat { width: 16px; height: 16px; border-radius: 4px; }
.legend-seat.normal { background: #4caf50; }
.legend-seat.available { background: #4caf50; }
.legend-seat.vip { background: #8e44ad; }
.legend-seat.couple { background: #2980b9; width: 26px; }
.legend-seat.sold { background: #2a2a2a; }
.legend-seat.is-booked { box-shadow: 0 0 6px 2px rgba(229, 9, 20, 0.8); border: 2px solid #e50914; }

.empty {
  text-align: center;
  padding: 80px 20px;
  color: rgba(255,255,255,0.5);
  font-size: 16px;
}
</style>
