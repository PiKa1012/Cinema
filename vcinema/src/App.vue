<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import { useRouter } from 'vue-router';
import LoginModal from './components/LoginModal.vue';

const router = useRouter();
const isLoggedIn = ref(false);
const username = ref('');
const userRole = ref('');
const showLogin = ref(false);

const checkLogin = () => {
  isLoggedIn.value = !!localStorage.getItem('token');
  username.value = localStorage.getItem('username') || '';
  userRole.value = localStorage.getItem('role') || '';
};

const logout = () => {
  localStorage.removeItem('token');
  localStorage.removeItem('userId');
  localStorage.removeItem('username');
  localStorage.removeItem('role');
  isLoggedIn.value = false;
  router.push('/');
};

const handleLoginSuccess = () => {
  checkLogin();
};

onMounted(() => {
  checkLogin();
  window.addEventListener('login-success', checkLogin);
  window.addEventListener('storage', checkLogin);
  window.addEventListener('show-login', () => { showLogin.value = true; });
});

onUnmounted(() => {
  window.removeEventListener('login-success', checkLogin);
  window.removeEventListener('storage', checkLogin);
  window.removeEventListener('show-login', () => { showLogin.value = true; });
});
</script>

<template>
  <header class="navbar">
    <div class="nav-container">
      <router-link to="/" class="logo">
        <span class="logo-icon">🎬</span>
        <span class="logo-text">影院</span>
      </router-link>
        <div class="nav-links">
          <router-link v-if="isLoggedIn && userRole === 'ADMIN'" to="/admin" class="nav-link admin">管理后台</router-link>
          <router-link v-if="isLoggedIn" to="/my-orders" class="nav-link">我的订单</router-link>
          <router-link v-if="isLoggedIn" to="/profile" class="nav-link">个人中心</router-link>
          <div class="user-info" v-if="isLoggedIn">
            <span class="username">{{ username }}</span>
            <button @click="logout" class="logout-btn">退出</button>
          </div>
          <button v-if="!isLoggedIn" @click="showLogin = true" class="login-btn">登录</button>
        </div>
    </div>
  </header>
  <div class="main-content">
    <router-view @login-success="checkLogin" />
  </div>
  <LoginModal :visible="showLogin" @close="showLogin = false" @login-success="handleLoginSuccess" />
</template>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #0f0f0f; }

.navbar {
  background: linear-gradient(90deg, #1a1a2e 0%, #16213e 100%);
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 2px 20px rgba(0,0,0,0.3);
}

.nav-container {
  margin: 0 auto;
  padding: 16px 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo {
  text-decoration: none;
  display: flex;
  align-items: center;
  gap: 8px;
}

.logo-icon {
  font-size: 28px;
}

.logo-text {
  font-size: 18px;
  font-weight: 500;
  color: #fff;
}

.nav-links {
  display: flex;
  align-items: center;
  gap: 20px;
}

.nav-link {
  color: rgba(255,255,255,0.7);
  text-decoration: none;
  font-size: 14px;
  padding: 8px 16px;
  border-radius: 8px;
  transition: all 0.3s;
}

.nav-link:hover {
  color: #fff;
  background: rgba(255,255,255,0.1);
}

.nav-link.admin {
  background: rgba(229, 9, 20, 0.2);
  color: #e50914;
}

.nav-link.admin:hover {
  background: rgba(229, 9, 20, 0.4);
}

.user-info {
  display: flex;
  align-items: center;
  gap: 16px;
}

.username {
  color: rgba(255,255,255,0.8);
  font-size: 14px;
}

.logout-btn {
  padding: 8px 18px;
  background: transparent;
  color: rgba(255,255,255,0.7);
  border: 1px solid rgba(255,255,255,0.3);
  border-radius: 8px;
  cursor: pointer;
  font-size: 13px;
  transition: all 0.3s;
}

.logout-btn:hover {
  background: rgba(255,255,255,0.1);
  color: #fff;
}

.login-btn {
  padding: 10px 24px;
  background: #e50914;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.login-btn:hover {
  background: #ff1744;
  transform: translateY(-2px);
}

.main-content { width: 100%; }
</style>
