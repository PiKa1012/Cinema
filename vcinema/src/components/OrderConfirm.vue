<template>
  <div class="order-confirm">
    <div v-if="order" class="confirm-box">
      <h1>订票成功!</h1>
      <div class="order-info">
        <p><strong>订单号:</strong> {{ order.orderNo }}</p>
        <p><strong>座位:</strong> {{ seatInfo }}</p>
        <p><strong>总价:</strong> ¥{{ order.totalPrice }}</p>
        <p><strong>状态:</strong> {{ order.status }}</p>
      </div>
      <button @click="$router.push('/')">返回首页</button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { orderApi } from '../api';

const route = useRoute();
const order = ref(null);
const seatInfo = ref('');

const loadOrder = async () => {
  try {
    const res = await orderApi.getByNo(route.params.orderNo);
    order.value = res.data;
    seatInfo.value = res.data.seats?.map(s => s.seatNo).join(', ') || '无';
  } catch (err) {
    console.error('加载失败', err);
  }
};

onMounted(loadOrder);
</script>

<style scoped>
.order-confirm { padding: 50px; text-align: center; }
.confirm-box { max-width: 400px; margin: 0 auto; padding: 30px; border: 1px solid #ddd; border-radius: 8px; }
.order-info { text-align: left; margin: 20px 0; }
.order-info p { margin: 10px 0; }
.confirm-box button { padding: 10px 30px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
</style>
