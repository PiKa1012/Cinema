<template>
  <div class="movie-detail">
    <div class="back-header">
      <button @click="$router.back()" class="back-btn">
        <span>←</span> 返回
      </button>
    </div>
    
    <div v-if="movie" class="detail-wrapper">
      <button @click="$router.back()" class="back-btn">
        <span>←</span>
      </button>
      <div class="poster-section">
        <img :src="getPosterUrl(movie.poster)" :alt="movie.title" />
      </div>
      
      <div class="info-section">
        <h1>{{ movie.title }}</h1>
        <div class="tags">
          <span class="tag">{{ movie.genre }}</span>
          <span class="tag" v-if="movie.duration">{{ movie.duration }}分钟</span>
          <span class="tag status-tag" :class="movie?.status">{{ movie?.status === 'showing' ? '热映中' : movie?.status === 'coming' ? '即将上映' : '已下架' }}</span>
        </div>
        
        <div class="meta-info">
          <div class="meta-item">
            <span class="label">导演</span>
            <span class="value">{{ movie.director || '未知' }}</span>
          </div>
          <div class="meta-item">
            <span class="label">演员</span>
            <span class="value">{{ movie.actors || '未知' }}</span>
          </div>
          <div class="meta-item">
            <span class="label">评分</span>
            <span class="value rating">{{ movie.rating || '暂无' }}</span>
          </div>
        </div>
        
        <div class="description">
          <h3>剧情简介</h3>
          <p>{{ movie.description || '暂无简介' }}</p>
        </div>
      </div>
    </div>
    
    <div class="sessions-section" v-if="movie && movie.status !== 'off' && sessions.length > 0">
      <h2>选择场次</h2>
      <div class="sessions-grid">
        <div v-for="session in sessions" :key="session.id" class="session-card">
          <div class="session-info">
            <div class="hall-name">{{ session.hallName }}</div>
            <div class="time">{{ formatTime(session.startTime) }}</div>
          </div>
          <div class="session-price">
            <span class="price">¥{{ session.price }}</span>
          </div>
          <button class="book-btn" @click="goToSeat(session)" :disabled="movie?.status === 'coming'">{{ movie?.status === 'coming' ? '即将上映' : '购票' }}</button>
        </div>
      </div>
    </div>
    
    <div v-else-if="movie && movie.status === 'coming'" class="no-sessions">
      <p>即将上映，敬请期待</p>
    </div>
    
    <div v-else-if="movie" class="no-sessions">
      <p>暂无场次安排</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { movieApi, sessionApi } from '../api';
import { config } from '../config';

const router = useRouter();
const route = useRoute();
const movie = ref(null);
const sessions = ref([]);

const loadData = async () => {
  const res = await movieApi.getById(route.params.id);
  movie.value = res.data;
  const sessionRes = await sessionApi.getByMovie(route.params.id);
  sessions.value = sessionRes.data.map(s => ({
    ...s,
    hallId: s.hall?.id,
    hallName: s.hall?.name || '默认放映厅'
  }));
};

const getPosterUrl = (poster) => {
  if (!poster) return '/placeholder.png';
  
  const isLocal = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1';
  const baseUrl = isLocal ? 'http://localhost:8080' : config.BACKEND_URL;

  if (poster.startsWith('http')) {
    return poster.replace(/http:\/\/localhost(:\d+)?\/api\/admin/, baseUrl);
  }
  if (poster.startsWith('/uploads')) {
    return baseUrl + poster;
  }
  return baseUrl + '/uploads' + poster;
};

const formatTime = (time) => {
  const date = new Date(time);
  return `${date.getMonth()+1}月${date.getDate()}日 ${date.getHours()}:${String(date.getMinutes()).padStart(2,'0')}`;
};

const goToSeat = (session) => {
  if (!localStorage.getItem('token')) {
    window.dispatchEvent(new CustomEvent('show-login'));
    return;
  }
  router.push(`/seat/${session.id}/${session.hallId}`);
};

onMounted(loadData);
</script>

<style scoped>
.movie-detail {
  min-height: 100vh;
  background: #0f0f0f;
  padding-bottom: 60px;
}

.detail-wrapper {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  display: flex;
  gap: 40px;
  position: relative;
}

.poster-section img {
  width: 300px;
  height: 420px;
  object-fit: cover;
  border-radius: 12px;
  box-shadow: 0 20px 40px rgba(0,0,0,0.5);
}

.info-section {
  flex: 1;
  color: #fff;
}

.back-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 36px;
  height: 36px;
  background: rgba(255,255,255,0.1);
  border: 1px solid rgba(255,255,255,0.2);
  border-radius: 50%;
  color: #fff;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  z-index: 10;
}

.back-btn:hover {
  background: rgba(255,255,255,0.2);
}

.info-section h1 {
  font-size: 36px;
  margin-bottom: 20px;
  color: #fff;
  font-weight: 700;
  text-shadow: 0 2px 10px rgba(0,0,0,0.5);
}

.tags {
  display: flex;
  gap: 10px;
  margin-bottom: 30px;
}

.tag {
  background: rgba(255,255,255,0.08);
  color: rgba(255,255,255,0.7);
  padding: 6px 14px;
  border-radius: 6px;
  font-size: 13px;
  border: 1px solid rgba(255,255,255,0.1);
}

.status-tag.showing {
  background: rgba(76, 175, 80, 0.2);
  color: #4caf50;
  border-color: rgba(76, 175, 80, 0.3);
}

.status-tag.coming {
  background: rgba(229, 9, 20, 0.2);
  color: #e50914;
  border-color: rgba(229, 9, 20, 0.3);
}

.status-tag.off {
  background: rgba(158, 158, 158, 0.2);
  color: #9e9e9e;
  border-color: rgba(158, 158, 158, 0.3);
}

.meta-info {
  display: flex;
  gap: 40px;
  margin-bottom: 30px;
}

.meta-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.meta-item .label {
  color: rgba(255,255,255,0.5);
  font-size: 14px;
}

.meta-item .value {
  font-size: 16px;
}

.meta-item .rating {
  color: #ffc107;
  font-size: 20px;
  font-weight: 600;
}

.description h3 {
  color: rgba(255,255,255,0.8);
  font-size: 18px;
  margin-bottom: 12px;
}

.description p {
  color: rgba(255,255,255,0.6);
  line-height: 1.8;
}

.sessions-section {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.sessions-section h2 {
  color: #fff;
  font-size: 24px;
  margin-bottom: 20px;
  padding-left: 15px;
  border-left: 4px solid #e50914;
}

.sessions-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}

.session-card {
  background: #1c1c1c;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 20px;
  transition: transform 0.3s, box-shadow 0.3s;
  border: 1px solid rgba(255,255,255,0.08);
}

.session-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 30px rgba(0,0,0,0.3);
}

.session-info {
  flex: 1;
}

.hall-name {
  color: rgba(255,255,255,0.9);
  font-size: 15px;
  margin-bottom: 6px;
}

.time {
  color: rgba(255,255,255,0.5);
  font-size: 13px;
}

.session-price .price {
  color: #fff;
  font-size: 20px;
  font-weight: 600;
}

.book-btn {
  background: #333;
  color: #fff;
  border: none;
  padding: 12px 24px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.3s;
}

.book-btn:hover {
  background: #444;
}

.book-btn:disabled {
  background: #222;
  color: #666;
  cursor: not-allowed;
}

.sessions-section h2 {
  color: rgba(255,255,255,0.9);
  font-size: 20px;
  margin-bottom: 20px;
  padding-left: 15px;
  border-left: 3px solid #333;
}

.no-sessions {
  max-width: 1200px;
  margin: 0 auto;
  padding: 60px 20px;
  text-align: center;
  color: rgba(255,255,255,0.5);
  font-size: 18px;
}
</style>
