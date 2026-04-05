import { createRouter, createWebHistory } from 'vue-router';
import MovieList from '../components/MovieList.vue';
import MovieDetail from '../components/MovieDetail.vue';
import SeatSelect from '../components/SeatSelect.vue';
import OrderConfirm from '../components/OrderConfirm.vue';
import AdminPage from '../components/AdminPage.vue';
import Profile from '../components/Profile.vue';
import MyOrders from '../components/MyOrders.vue';

const routes = [
  { path: '/', name: 'home', component: MovieList },
  { path: '/admin', name: 'admin', component: AdminPage },
  { path: '/profile', name: 'profile', component: Profile },
  { path: '/my-orders', name: 'my-orders', component: MyOrders },
  { path: '/movie/:id', name: 'movie-detail', component: MovieDetail },
  { path: '/seat/:sessionId/:hallId', name: 'seat-select', component: SeatSelect },
  { path: '/order/:orderNo', name: 'order-confirm', component: OrderConfirm }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token');
  const role = localStorage.getItem('role');
  
  if (to.path === '/admin') {
    if (!token) {
      window.dispatchEvent(new CustomEvent('show-login'));
      return next('/');
    }
    if (role !== 'ADMIN') {
      return next('/');
    }
  }
  
  if ((to.path === '/profile' || to.path === '/my-orders') && !token) {
    window.dispatchEvent(new CustomEvent('show-login'));
    return next('/');
  }
  
  next();
});

export default router;
