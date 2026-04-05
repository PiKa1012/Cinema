<template>
  <div class="profile-page">
    <div class="profile-card">
      <h2>个人信息</h2>
      
      <div class="form-group">
        <label>账号</label>
        <input v-model="userInfo.username" disabled class="input-disabled">
      </div>
      
      <div class="form-group">
        <label>昵称</label>
        <input v-model="userInfo.nickname" placeholder="请输入昵称">
      </div>
      
      <div class="form-group">
        <label>新密码（留空则不修改）</label>
        <input v-model="userInfo.password" type="password" placeholder="请输入新密码">
      </div>
      
      <div class="form-group">
        <label>角色</label>
        <input :value="userInfo.role === 'ADMIN' ? '管理员' : '普通用户'" disabled class="input-disabled">
      </div>
      
      <div class="btn-group">
        <button class="save-btn" @click="saveProfile">保存修改</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
import { authApi } from '../api';
import { useRouter } from 'vue-router';

const router = useRouter();
const userInfo = reactive({
  username: '',
  nickname: '',
  password: '',
  role: ''
});

const loadUser = async () => {
  try {
    const res = await authApi.getUser();
    userInfo.username = res.data.username;
    userInfo.nickname = res.data.nickname;
    userInfo.role = res.data.role;
    userInfo.password = '';
  } catch (e) {
    console.error(e);
    router.push('/login');
  }
};

const saveProfile = async () => {
  try {
    await authApi.updateUser({
      nickname: userInfo.nickname,
      password: userInfo.password || null
    });
    alert('保存成功');
    userInfo.password = '';
  } catch (e) {
    alert('保存失败');
  }
};

onMounted(loadUser);
</script>

<style scoped>
.profile-page {
  min-height: calc(100vh - 52px);
  display: flex;
  justify-content: center;
  align-items: center;
  background: #0f0f0f;
  padding: 40px 20px;
}

.profile-card {
  background: #1c1c1c;
  border-radius: 12px;
  padding: 32px;
  width: 100%;
  max-width: 420px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.3);
}

.profile-card h2 {
  color: #fff;
  font-size: 20px;
  font-weight: 500;
  margin-bottom: 28px;
  text-align: center;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  color: rgba(255,255,255,0.6);
  font-size: 14px;
  margin-bottom: 8px;
}

.form-group input {
  width: 100%;
  padding: 12px 14px;
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 8px;
  font-size: 14px;
  background: #2a2a2a;
  color: #fff;
  transition: border-color 0.2s;
}

.form-group input:focus {
  outline: none;
  border-color: #4fc3f7;
}

.form-group input.input-disabled {
  background: #252525;
  color: rgba(255,255,255,0.4);
  cursor: not-allowed;
}

.btn-group {
  margin-top: 28px;
}

.save-btn {
  width: 100%;
  padding: 12px;
  background: #4fc3f7;
  color: #1c1c1c;
  border: none;
  border-radius: 8px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
}

.save-btn:hover {
  background: #29b6f6;
}
</style>
