<template>
  <div v-if="visible" class="modal-mask" @click.self="$emit('close')">
    <div class="modal-box">
      <div class="modal-header">
        {{ isRegister ? '注册' : '登录' }}
        <span class="close-btn" @click="$emit('close')">✕</span>
      </div>
      <div class="modal-body">
        <div class="form-item">
          <label>用户名</label>
          <input v-model="form.username" placeholder="请输入用户名">
        </div>
        <div class="form-item">
          <label>密码</label>
          <input v-model="form.password" type="password" placeholder="请输入密码">
        </div>
        <div class="form-item" v-if="isRegister">
          <label>昵称</label>
          <input v-model="form.nickname" placeholder="请输入昵称（选填）">
        </div>
        <button class="submit-btn" @click="submit">{{ isRegister ? '注册' : '登录' }}</button>
        <p class="switch" @click="isRegister = !isRegister">
          {{ isRegister ? '已有账号？去登录' : '没有账号？去注册' }}
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue';
import { authApi } from '../api';

const props = defineProps({
  visible: Boolean
});

const emit = defineEmits(['close', 'login-success']);

const isRegister = ref(false);
const form = reactive({ username: '', password: '', nickname: '' });

const submit = async () => {
  try {
    const api = isRegister.value ? authApi.register : authApi.login;
    const res = await api({ username: form.username, password: form.password });
    
    localStorage.setItem('token', res.data.token);
    localStorage.setItem('userId', res.data.userId);
    localStorage.setItem('username', res.data.username);
    localStorage.setItem('role', res.data.role);
    
    window.dispatchEvent(new Event('login-success'));
    emit('login-success');
    emit('close');
    
    form.username = '';
    form.password = '';
    form.nickname = '';
  } catch (err) {
    if (err.response?.status === 403) {
      alert('该账号已被封禁');
    } else {
      alert(isRegister.value ? '注册失败' : '用户名或密码错误');
    }
  }
};
</script>

<style scoped>
.modal-mask {
  position: fixed; top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(0,0,0,0.7); display: flex; justify-content: center;
  align-items: center; z-index: 1000; backdrop-filter: blur(4px);
}

.modal-box {
  background: #1c1c1c; border-radius: 12px; width: 380px;
  overflow: hidden; box-shadow: 0 20px 60px rgba(0,0,0,0.5);
}

.modal-header {
  padding: 20px 24px; border-bottom: 1px solid rgba(255,255,255,0.08);
  font-size: 16px; font-weight: 600; color: #fff; position: relative;
}

.close-btn {
  position: absolute; right: 20px; top: 50%; transform: translateY(-50%);
  cursor: pointer; color: rgba(255,255,255,0.5); font-size: 18px;
}

.close-btn:hover { color: #fff; }

.modal-body { padding: 24px; }

.form-item { margin-bottom: 18px; }

.form-item label {
  display: block; font-size: 14px; color: rgba(255,255,255,0.6); margin-bottom: 8px;
}

.form-item input {
  width: 100%; padding: 12px; border: 1px solid rgba(255,255,255,0.1);
  border-radius: 6px; font-size: 14px; background: #333; color: #fff;
  transition: border-color 0.2s;
}

.form-item input:focus { outline: none; border-color: #4fc3f7; }

.submit-btn {
  width: 100%; padding: 12px; background: #e50914; color: #fff;
  border: none; border-radius: 6px; cursor: pointer; font-size: 15px;
  font-weight: 600; transition: background 0.2s; margin-top: 8px;
}

.submit-btn:hover { background: #ff1744; }

.switch {
  text-align: center; margin-top: 16px; color: rgba(255,255,255,0.5);
  cursor: pointer; font-size: 14px;
}

.switch:hover { color: #4fc3f7; }
</style>
