<template>
  <div class="movie-list">
    <div class="hero">
      <div class="hero-content">
        <h1>发现好电影</h1>
        <p>最新热映影片推荐</p>
      </div>
    </div>
    <div class="container">
      <h2 class="section-title">热映推荐</h2>
      <div class="movie-grid">
        <div v-for="movie in showingMovies" :key="movie.id" class="movie-card" @click="goToDetail(movie.id)">
          <div class="poster-wrapper">
            <img :src="getPosterUrl(movie.poster)" :alt="movie.title" />
            <div class="rating" v-if="movie.rating">
              <span>{{ movie.rating }}</span>
            </div>
          </div>
          <h3>{{ movie.title }}</h3>
          <div class="movie-info">
            <span class="genre">{{ movie.genre }}</span>
            <span class="duration">{{ movie.duration }}分钟</span>
          </div>
        </div>
      </div>
      <div v-if="showingMovies.length === 0" class="empty">
        <p>暂无热映电影</p>
      </div>

      <h2 class="section-title" v-if="comingMovies.length > 0" style="margin-top: 50px;">即将上映</h2>
      <div class="movie-grid" v-if="comingMovies.length > 0">
        <div v-for="movie in comingMovies" :key="movie.id" class="movie-card" @click="goToDetail(movie.id)">
          <div class="poster-wrapper coming">
            <img :src="getPosterUrl(movie.poster)" :alt="movie.title" />
            <div class="coming-tag">即将上映</div>
          </div>
          <h3>{{ movie.title }}</h3>
          <div class="movie-info">
            <span class="genre">{{ movie.genre }}</span>
            <span class="duration">{{ movie.duration }}分钟</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { movieApi } from '../api';
import { config } from '../config';

const router = useRouter();
const showingMovies = ref([]);
const comingMovies = ref([]);

const loadMovies = async () => {
  try {
    const res = await movieApi.getAll();
    const allMovies = res.data;
    showingMovies.value = allMovies.filter(m => m.status === 'showing');
    comingMovies.value = allMovies.filter(m => m.status === 'coming');
  } catch (err) {
    console.error('加载失败', err);
  }
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

const goToDetail = (id) => {
  router.push(`/movie/${id}`);
};

onMounted(loadMovies);
</script>

<style scoped>
.movie-list {
  min-height: 100vh;
  background: #0f0f0f;
}

.hero {
  background: linear-gradient(135deg, #0d0d0d 0%, #1a1a1a 50%, #0d0d0d 100%);
  padding: 60px 20px;
  text-align: center;
}

.hero-content h1 {
  font-size: 42px;
  color: #fff;
  margin-bottom: 10px;
  font-weight: 600;
}

.hero-content p {
  font-size: 16px;
  color: rgba(255,255,255,0.5);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px;
}

.section-title {
  color: rgba(255,255,255,0.9);
  font-size: 20px;
  margin-bottom: 30px;
  padding-left: 10px;
  border-left: 3px solid #333;
}

.movie-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 30px;
}

.movie-card {
  cursor: pointer;
  transition: transform 0.3s ease;
}

.movie-card:hover {
  transform: translateY(-10px);
}

.poster-wrapper {
  position: relative;
  border-radius: 12px;
  overflow: hidden;
  margin-bottom: 12px;
}

.movie-card img {
  width: 100%;
  height: 260px;
  object-fit: cover;
  display: block;
}

.rating {
  position: absolute;
  top: 10px;
  right: 10px;
  background: rgba(0,0,0,0.7);
  color: #fff;
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 600;
}

.poster-wrapper.coming {
  opacity: 0.7;
}

.coming-tag {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background: rgba(229, 9, 20, 0.9);
  color: #fff;
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 600;
}

.movie-card h3 {
  color: #fff;
  font-size: 16px;
  margin-bottom: 8px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.movie-info {
  display: flex;
  justify-content: space-between;
  font-size: 13px;
  color: rgba(255,255,255,0.5);
}

.genre {
  background: rgba(255,255,255,0.1);
  padding: 3px 8px;
  border-radius: 4px;
}

.empty {
  text-align: center;
  padding: 60px;
  color: rgba(255,255,255,0.5);
  font-size: 18px;
}
</style>
