import axios from 'axios';
import { config } from '../config';

const isDev = import.meta.env.DEV;

const api = axios.create({
  baseURL: isDev ? '/api' : config.BACKEND_URL + '/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
});

api.interceptors.request.use(config => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const movieApi = {
  getAll: () => api.get('/movies'),
  getShowing: () => api.get('/movies/showing'),
  getById: (id) => api.get(`/movies/${id}`),
  create: (data) => api.post('/admin/movies', data),
  update: (id, data) => api.put(`/admin/movies/${id}`, data),
  delete: (id) => api.delete(`/admin/movies/${id}`)
};

export const uploadApi = {
  upload: (file) => {
    const formData = new FormData();
    formData.append('file', file);
    const url = (isDev ? '' : config.BACKEND_URL) + '/api/admin/upload';
    return axios.post(url, formData, {
      timeout: 60000
    });
  }
};

export const sessionApi = {
  getAll: () => api.get('/sessions'),
  getById: (id) => api.get(`/sessions/${id}`),
  getByMovie: (movieId) => api.get(`/sessions/movie/${movieId}`),
  getByHall: (hallId) => api.get(`/sessions/hall/${hallId}`),
  create: (data) => api.post('/sessions', data),
  update: (id, data) => api.put(`/sessions/${id}`, data),
  delete: (id) => api.delete(`/sessions/${id}`)
};

export const seatApi = {
  getByHall: (hallId) => api.get(`/seats/hall/${hallId}`),
  getAvailable: (hallId, sessionId) => api.get(`/seats/hall/${hallId}/session/${sessionId}`),
  create: (data) => api.post('/seats', data)
};

export const orderApi = {
  getAll: () => api.get('/orders'),
  getById: (id) => api.get(`/orders/${id}`),
  getByNo: (orderNo) => api.get(`/orders/no/${orderNo}`),
  getByUser: (userId) => api.get(`/orders/user/${userId}`),
  create: (data) => api.post('/orders', data),
  confirm: (id) => api.put(`/orders/${id}/confirm`),
  cancel: (id) => api.put(`/orders/${id}/cancel`)
};

export const authApi = {
  login: (data) => api.post('/auth/login', data),
  register: (data) => api.post('/auth/register', data),
  getUser: () => api.get('/auth/user'),
  updateUser: (data) => api.put('/auth/user', data)
};

export const adminApi = {
  getUsers: () => api.get('/admin/users'),
  createUser: (data) => api.post('/admin/users', data),
  deleteUser: (id) => api.delete(`/admin/users/${id}`),
  resetPassword: (id, data) => api.put(`/admin/users/${id}/password`, data),
  banUser: (id) => api.put(`/admin/users/${id}/ban`),
  unbanUser: (id) => api.put(`/admin/users/${id}/unban`),
  getOrders: () => api.get('/admin/orders'),
  getOrderDetail: (id) => api.get(`/admin/orders/${id}`),
  updateOrderStatus: (id, status) => api.put(`/admin/orders/${id}/status?status=${status}`),
  getMovies: () => api.get('/admin/movies'),
  createMovie: (data) => api.post('/admin/movies', data),
  updateMovie: (id, data) => api.put(`/admin/movies/${id}`, data),
  deleteMovie: (id) => api.delete(`/admin/movies/${id}`),
  getHalls: () => api.get('/admin/halls'),
  createHall: (data) => api.post('/admin/halls', data),
  deleteHall: (id) => api.delete(`/admin/halls/${id}`),
  getSessions: () => api.get('/admin/sessions'),
  createSession: (data) => api.post('/admin/sessions', data),
  updateSession: (id, data) => api.put(`/admin/sessions/${id}`, data),
  deleteSession: (id) => api.delete(`/admin/sessions/${id}`),
  getHallSeats: (hallId) => api.get(`/admin/seats/hall/${hallId}`),
  updateSeat: (id, data) => api.put(`/admin/seats/${id}`, data),
  deleteSeat: (id) => api.delete(`/admin/seats/${id}`)
};

export default api;
