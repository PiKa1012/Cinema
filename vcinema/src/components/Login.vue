<template>
  <div class="login-page">
    <div class="login-box">
      <h1>{{ isRegister ? '注册' : '登录' }}</h1>
      <form @submit.prevent="submit">
        <div class="form-group">
          <input v-model="form.username" placeholder="用户名" required />
        </div>
        <div class="form-group">
          <input v-model="form.password" type="password" placeholder="密码" required />
        </div>
        <button type="submit">{{ isRegister ? '注册' : '登录' }}</button>
      </form>
      <p class="switch" @click="isRegister = !isRegister">
        {{ isRegister ? '已有账号？去登录' : '没有账号？去注册' }}
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { authApi } from '../api';

const router = useRouter();
const route = useRoute();
const isRegister = ref(false);
const form = reactive({ username: '', password: '' });

const submit = async () => {
  try {
    const api = isRegister.value ? authApi.register : authApi.login;
    const res = await api(form);
    
    localStorage.setItem('token', res.data.token);
    localStorage.setItem('userId', res.data.userId);
    localStorage.setItem('username', res.data.username);
    localStorage.setItem('role', res.data.role);
    
    window.dispatchEvent(new Event('login-success'));
    const redirect = route.query.redirect || '/';
    router.push(redirect);
  } catch (err) {
    alert(isRegister.value ? '注册失败' : '用户名或密码错误');
  }
};
</script>

<style scoped>
.login-page { display: flex; justify-content: center; align-items: center; height: 100vh; background: #f5f5f5; }
.login-box { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 300px; }
.login-box h1 { text-align: center; margin-bottom: 30px; }
.form-group { margin-bottom: 20px; }
.form-group input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
button { width: 100%; padding: 12px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
button:hover { background: #45a049; }
.switch { text-align: center; margin-top: 20px; color: #666; cursor: pointer; }
.switch:hover { color: #4CAF50; }
</style>
