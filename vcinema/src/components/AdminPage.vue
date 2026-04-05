<template>
  <div class="admin-page">
    <div class="sidebar">
      <div class="logo">后台管理</div>
      <a v-for="item in menuItems" :key="item.key" :class="{ active: activeTab === item.key }" @click="activeTab = item.key">
        {{ item.label }}
      </a>
    </div>
    
    <div class="main">
      <div class="page-header">
        <h2>{{ tabTitle }}</h2>
        <button v-if="canAdd" class="add-btn" @click="showModal(activeTab)">+ 新增</button>
      </div>
      
      <!-- 放映厅管理带座位 -->
      <div v-if="activeTab === 'halls'" class="panel">
        <table v-if="currentData.length > 0">
          <thead>
            <tr>
              <th v-for="col in columns" :key="col.key">{{ col.label }}</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in currentData" :key="item.id">
              <td v-for="col in columns" :key="col.key">{{ getCellValue(item, col.key) }}</td>
              <td>
                <span class="action-btn edit" @click="toggleHallSeats(item)">{{ expandedHallId === item.id ? '收起' : '设置座位' }}</span>
                <span class="action-btn delete" @click="deleteItem(item.id)">删除</span>
              </td>
            </tr>
          </tbody>
        </table>

        <!-- 座位设置区域 -->
        <div v-if="expandedHallId" class="seat-admin" style="margin-top: 30px;">
          <div style="margin-bottom: 15px; font-weight: 600;">正在设置: {{ expandedHallName }} ({{ expandedHallRows }}行 x {{ expandedHallCols }}列)</div>
          <div class="screen-area"><div class="screen">银幕</div></div>
          <div class="seat-grid">
            <div class="seat-row" v-for="(row, i) in seatGrid" :key="i">
              <span class="row-label">{{ String.fromCharCode(65 + i) }}</span>
              <div class="seats">
                <div v-for="seat in row" :key="seat.id" 
                     class="seat" 
                     :class="getSeatClass(seat)"
                     :title="seat.seatNo"
                     @click="toggleSeatType(seat)">
                </div>
              </div>
            </div>
          </div>
          <div class="legend">
            <span class="legend-item"><span class="legend-seat normal"></span> 普通</span>
            <span class="legend-item"><span class="legend-seat vip"></span> VIP</span>
            <span class="legend-item"><span class="legend-seat couple"></span> 情侣座</span>
          </div>
        </div>
      </div>

      <!-- 其他标签的通用表格 -->
      <div v-else class="panel">
        <table v-if="hasData">
          <thead>
            <tr>
              <th v-for="col in columns" :key="col.key">{{ col.label }}</th>
              <th v-if="hasActions">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in currentData" :key="item.id">
              <td v-for="col in columns" :key="col.key">{{ getCellValue(item, col.key) }}</td>
              <td v-if="hasActions">
                <span v-if="activeTab === 'users'" class="action-btn edit" @click="showResetPassword(item)">改密</span>
                <span v-if="activeTab === 'users'" class="action-btn" :class="item.role === 'BANNED' ? 'edit' : 'ban'" @click="toggleBan(item)">{{ item.role === 'BANNED' ? '解封' : '封禁' }}</span>
                <span v-if="activeTab === 'orders'" class="action-btn" @click="viewOrderDetail(item)">详情</span>
                <span v-if="activeTab === 'movies'" class="action-btn edit" @click="editItem(item)">编辑</span>
                <span v-if="activeTab === 'sessions'" class="action-btn" @click="viewSessionDetail(item)">详情</span>
                <span v-if="activeTab === 'sessions'" class="action-btn edit" @click="editItem(item)">编辑</span>
                <span class="action-btn delete" @click="deleteItem(item.id)">删除</span>
              </td>
            </tr>
          </tbody>
        </table>
        <div v-else class="empty">暂无数据</div>
      </div>
    </div>

    <!-- 弹窗 -->
    <div v-if="modalVisible" class="modal-mask" @click.self="modalVisible = false">
      <div class="modal-box">
        <div class="modal-header">{{ modalTitle }}</div>
        <div class="modal-body">
          <div v-for="field in formFields" :key="field.key" class="form-item">
            <label>{{ field.label }}</label>
            <input v-if="field.type === 'text'" v-model="formData[field.key]" :placeholder="field.label">
            <input v-if="field.type === 'number'" v-model="formData[field.key]" type="number" :placeholder="field.label">
            <input v-if="field.type === 'password'" v-model="formData[field.key]" type="password" :placeholder="field.label">
            <textarea v-if="field.type === 'textarea'" v-model="formData[field.key]" :placeholder="field.label" rows="3"></textarea>
            <select v-if="field.type === 'select'" v-model="formData[field.key]">
              <option v-for="opt in field.options" :value="opt.value">{{ opt.label }}</option>
            </select>
            <select v-if="field.type === 'movie'" v-model="formData[field.key]">
              <option value="">选择电影</option>
              <option v-for="m in movies" :value="m.id">{{ m.title }}</option>
            </select>
            <select v-if="field.type === 'hall'" v-model="formData[field.key]">
              <option value="">选择放映厅</option>
              <option v-for="h in halls" :value="h.id">{{ h.name }}</option>
            </select>
            <input v-if="field.type === 'datetime'" v-model="formData[field.key]" type="datetime-local">
            <div v-if="field.type === 'file'" class="file-input">
              <input type="file" @change="handleFileUpload($event, field.key)" accept="image/*">
              <img v-if="formData[field.key]" :src="getPreviewUrl(formData[field.key])" class="preview-img">
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-cancel" @click="modalVisible = false">取消</button>
          <button class="btn-confirm" @click="submitForm">确定</button>
        </div>
      </div>
    </div>

    <!-- 详情弹窗 -->
    <div v-if="detailModalVisible" class="modal-mask" @click.self="detailModalVisible = false">
      <!-- 订单详情 -->
      <div v-if="detailOrder" class="modal-box" style="width: 600px;">
        <div class="modal-header">
          订单详情
          <span style="float: right; cursor: pointer;" @click="detailModalVisible = false">✕</span>
        </div>
        <div class="modal-body" style="max-height: 500px; overflow-y: auto;">
          <div class="movie-detail-info">
            <div class="detail-row"><span class="label">订单号：</span><span class="value">{{ detailOrder.orderNo }}</span></div>
            <div class="detail-row"><span class="label">用户：</span><span class="value">{{ detailOrder.user?.username }}</span></div>
            <div class="detail-row"><span class="label">电影：</span><span class="value">{{ detailOrder.session?.movie?.title }}</span></div>
            <div class="detail-row"><span class="label">放映厅：</span><span class="value">{{ detailOrder.session?.hall?.name }}</span></div>
            <div class="detail-row"><span class="label">场次：</span><span class="value">{{ formatTime(detailOrder.session?.startTime) }}</span></div>
            <div class="detail-row"><span class="label">金额：</span><span class="value">¥{{ detailOrder.totalPrice }}</span></div>
            <div class="detail-row"><span class="label">状态：</span><span class="value">{{ detailOrder.status === 'paid' ? '已支付' : detailOrder.status === 'pending' ? '待支付' : detailOrder.status === 'cancelled' ? '已取消' : detailOrder.status }}</span></div>
            <div class="detail-row"><span class="label">时间：</span><span class="value">{{ formatTime(detailOrder.createTime) }}</span></div>
          </div>

          <div class="order-seats-section" v-if="detailOrder.seats && detailOrder.seats.length > 0">
            <h3 class="seats-title">已选座位</h3>
            <div class="seat-admin">
              <div class="screen-area"><div class="screen">银幕</div></div>
              <div class="seat-grid">
                <div class="seat-row" v-for="(row, i) in orderSeatGrid" :key="i">
                  <span class="row-label">{{ String.fromCharCode(65 + i) }}</span>
                  <div class="seats">
                    <div v-for="seat in row" :key="seat.id" 
                         class="seat" 
                         :class="getOrderSeatClass(seat)"
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
                <span class="legend-item"><span class="legend-seat is-booked"></span> 本订单</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 场次详情 -->
      <div v-else class="modal-box" style="width: 600px;">
        <div class="modal-header">
          场次座位详情
          <span style="float: right; cursor: pointer;" @click="detailModalVisible = false">✕</span>
        </div>
        <div class="modal-body" style="max-height: 500px; overflow-y: auto;">
          <div v-if="detailSession" style="margin-bottom: 15px; color: #aaa;">
            <strong>{{ detailSession.movie?.title }}</strong> - {{ detailSession.hall?.name }} - {{ detailSession.startTime }}
          </div>
          <div class="seat-admin">
            <div class="screen-area"><div class="screen">银幕</div></div>
            <div class="seat-grid">
              <div class="seat-row" v-for="(row, i) in detailSeatGrid" :key="i">
                <span class="row-label">{{ String.fromCharCode(65 + i) }}</span>
                <div class="seats">
                  <div v-for="seat in row" :key="seat.id" 
                       class="seat" 
                       :class="getDetailSeatClass(seat)"
                       :title="seat.seatNo"
                       :style="{ cursor: canEditSeats ? 'pointer' : 'not-allowed', opacity: canEditSeats ? 1 : 0.6 }"
                       @click="canEditSeats && toggleSeatType(seat)">
                  </div>
                </div>
              </div>
            </div>
            <div class="legend">
              <span class="legend-item"><span class="legend-seat available"></span> 普通</span>
              <span class="legend-item"><span class="legend-seat vip"></span> VIP</span>
              <span class="legend-item"><span class="legend-seat couple"></span> 情侣座</span>
              <span class="legend-item"><span class="legend-seat sold"></span> 已售</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue';
import { adminApi, uploadApi } from '../api';
import { config } from '../config';

const activeTab = ref('users');
const users = ref([]);
const orders = ref([]);
const movies = ref([]);
const halls = ref([]);
const sessions = ref([]);
const hallSeats = ref([]);
const seatTypeFilter = ref('');

const detailModalVisible = ref(false);
const detailSession = ref(null);
const detailSeats = ref([]);
const detailOrder = ref(null);
const orderAllSeats = ref([]);
const modalVisible = ref(false);
const modalType = ref('');
const formData = reactive({});

const menuItems = [
  { key: 'users', label: '用户' },
  { key: 'orders', label: '订单' },
  { key: 'movies', label: '电影' },
  { key: 'halls', label: '放映厅' },
  { key: 'sessions', label: '场次' }
];

const tabTitle = computed(() => ({ users: '用户管理', orders: '订单管理', movies: '电影管理', halls: '放映厅管理', sessions: '场次管理' }[activeTab.value]));
const canAdd = computed(() => ['users','movies','halls','sessions'].includes(activeTab.value));
const modalTitle = computed(() => ({ users: '新增用户', movies: '新增电影', movies_edit: '编辑电影', halls: '新增放映厅', sessions: '新增场次', sessions_edit: '编辑场次' }[activeTab.value]));
const hasData = computed(() => currentData.value.length > 0);
const hasActions = computed(() => ['users','movies','halls','sessions','orders'].includes(activeTab.value));
const filteredSeats = computed(() => seatTypeFilter.value ? hallSeats.value.filter(s => s.type === seatTypeFilter.value) : hallSeats.value);

const currentData = computed(() => ({ users: users.value, orders: orders.value, movies: movies.value, halls: halls.value, sessions: sessions.value, seats: hallSeats.value }[activeTab.value] || []));

const columns = computed(() => {
  const cols = { users: [{key:'id',label:'ID'},{key:'username',label:'账号'},{key:'nickname',label:'昵称'},{key:'role',label:'角色'}],
    orders: [{key:'id',label:'ID'},{key:'orderNo',label:'订单号'},{key:'user',label:'用户',format:v=>v?.username||v?.id}, {key:'session',label:'场次',format:v=>v?.id}, {key:'totalPrice',label:'金额'},{key:'status',label:'状态'}],
    movies: [{key:'id',label:'ID'},{key:'title',label:'名称'},{key:'director',label:'导演'},{key:'actors',label:'演员'},{key:'genre',label:'类型'},{key:'duration',label:'时长'},{key:'rating',label:'评分'},{key:'status',label:'状态'}],
    halls: [{key:'id',label:'ID'},{key:'name',label:'名称'},{key:'rows',label:'行'},{key:'columns',label:'列'},{key:'type',label:'类型'}],
    sessions: [{key:'id',label:'ID'},{key:'movie',label:'电影'},{key:'hall',label:'放映厅'},{key:'startTime',label:'时间'},{key:'price',label:'价格'},{key:'sold',label:'已售'},{key:'status',label:'状态'}]
  };
  return cols[activeTab.value] || [];
});

const formFields = computed(() => {
  const fields = {
    users: [{key:'username',label:'用户名',type:'text'},{key:'password',label:'密码',type:'password'},{key:'nickname',label:'昵称',type:'text'},{key:'role',label:'角色',type:'select',options:[{value:'USER',label:'普通用户'},{value:'ADMIN',label:'管理员'}]}],
    movies: [{key:'title',label:'电影名',type:'text'},{key:'director',label:'导演',type:'text'},{key:'actors',label:'演员',type:'text'},{key:'genre',label:'类型',type:'text'},{key:'duration',label:'时长(分钟)',type:'number'},{key:'rating',label:'评分',type:'number'},{key:'poster',label:'海报',type:'file'},{key:'status',label:'状态',type:'select',options:[{value:'showing',label:'热映中'},{value:'coming',label:'即将上映'},{value:'off',label:'已下架'}]}, {key:'description',label:'简介',type:'textarea'}],
    halls: [{key:'name',label:'名称',type:'text'},{key:'rows',label:'行数',type:'number'},{key:'columns',label:'列数',type:'number'},{key:'type',label:'类型',type:'select',options:[{value:'普通',label:'普通'},{value:'VIP',label:'VIP'}]}],
    sessions: [{key:'movieId',label:'电影',type:'movie'},{key:'hallId',label:'放映厅',type:'hall'},{key:'price',label:'价格',type:'number'},{key:'startTime',label:'时间',type:'datetime'}]
  };
  return fields[activeTab.value] || [];
});

const getCellValue = (item, key) => {
  if (key === 'totalPrice') return `¥${item.totalPrice}`;
  if (key === 'duration') return `${item.duration}分钟`;
  if (key === 'rating') return item.rating ? `${item.rating}分` : '-';
  if (key === 'startTime') return item.startTime ? new Date(item.startTime).toLocaleString('zh-CN') : '-';
  if (key === 'movie') return item.movie?.title || '-';
  if (key === 'hall') return item.hall?.name || '-';
  if (key === 'user') return item.user?.username || item.user?.id || '-';
  if (key === 'session') return item.session?.id || '-';
  if (key === 'userId') return users.value.find(u => u.id === item.userId)?.username || item.userId;
  return item[key];
};

const loadData = async () => {
  const [u, o, m, h, s] = await Promise.all([adminApi.getUsers(), adminApi.getOrders(), adminApi.getMovies(), adminApi.getHalls(), adminApi.getSessions()]);
  users.value = u.data; orders.value = o.data; movies.value = m.data; halls.value = h.data; sessions.value = s.data;
};

const showModal = (type) => {
  const defaults = { users: {username:'',password:'',nickname:'',role:'USER'}, movies: {title:'',director:'',actors:'',genre:'',duration:'',rating:'',poster:'',description:'',status:'showing'}, halls: {name:'',rows:8,columns:10,type:'普通'}, sessions: {movieId:'',hallId:'',price:'',startTime:''} };
  modalType.value = type;
  Object.assign(formData, defaults[type] || {}); 
  modalVisible.value = true;
};

const submitForm = async () => {
  if (activeTab.value === 'users') await adminApi.createUser(formData);
  else if (activeTab.value === 'movies' || modalType.value === 'movies_edit') {
    if (modalType.value === 'movies_edit') {
      await adminApi.updateMovie(formData.id, formData);
    } else {
      await adminApi.createMovie({...formData, status:'showing'});
    }
  } else if (activeTab.value === 'halls') await adminApi.createHall(formData);
  else if (activeTab.value === 'sessions' || modalType.value === 'sessions_edit') {
    const m = movies.value.find(x => x.id == formData.movieId);
    const h = halls.value.find(x => x.id == formData.hallId);
    const sessionData = {movie:{id:m.id},hall:{id:h.id},price:parseFloat(formData.price),startTime:formData.startTime,endTime:formData.startTime,status:'available'};
    if (modalType.value === 'sessions_edit') {
      sessionData.id = formData.id;
      await adminApi.updateSession(formData.id, sessionData);
    } else {
      await adminApi.createSession(sessionData);
    }
  }
  modalVisible.value = false; loadData();
};

const handleFileUpload = async (event, key) => {
  const file = event.target.files[0];
  if (!file) return;
  try {
    const res = await uploadApi.upload(file);
    formData[key] = res.data.url;
    alert('上传成功');
  } catch (e) {
    console.error('上传失败', e);
    alert('上传失败: ' + (e.message || '未知错误'));
  }
};

const getPreviewUrl = (url) => {
  if (!url) return '';
  const isLocal = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1';
  const baseUrl = isLocal ? 'http://localhost:8080' : config.BACKEND_URL;
  if (url.startsWith('http')) return url;
  return baseUrl + url;
};

const deleteItem = async (id) => {
  if (!confirm('确定删除？')) return;
  if (activeTab.value === 'users') await adminApi.deleteUser(id);
  else if (activeTab.value === 'movies') await adminApi.deleteMovie(id);
  else if (activeTab.value === 'halls') await adminApi.deleteHall(id);
  else if (activeTab.value === 'sessions') await adminApi.deleteSession(id);
  loadData();
};

const showResetPassword = async (user) => {
  const password = prompt('请输入新密码：');
  if (!password) return;
  try {
    await adminApi.resetPassword(user.id, { password });
    alert('密码修改成功');
  } catch (e) {
    alert('修改失败');
  }
};

const toggleBan = async (user) => {
  const isBanned = user.role === 'BANNED';
  const action = isBanned ? '解封' : '封禁';
  if (!confirm(`确定${action}用户 ${user.username}？`)) return;
  try {
    if (isBanned) {
      await adminApi.unbanUser(user.id);
    } else {
      await adminApi.banUser(user.id);
    }
    loadData();
  } catch (e) {
    alert('操作失败');
  }
};

const editItem = async (item) => {
  if (activeTab.value === 'movies') {
    modalType.value = 'movies_edit';
    Object.assign(formData, {
      id: item.id,
      title: item.title,
      director: item.director,
      actors: item.actors,
      genre: item.genre,
      duration: item.duration,
      rating: item.rating,
      poster: item.poster,
      description: item.description,
      status: item.status
    });
    modalVisible.value = true;
  } else if (activeTab.value === 'sessions') {
    modalType.value = 'sessions_edit';
    Object.assign(formData, {
      id: item.id,
      movieId: item.movie?.id || item.movieId,
      hallId: item.hall?.id || item.hallId,
      price: item.price,
      startTime: item.startTime ? item.startTime.slice(0, 16) : ''
    });
    modalVisible.value = true;
  }
};

const detailSeatGrid = computed(() => {
  const rows = {};
  detailSeats.value.forEach(seat => {
    if (!rows[seat.rowNum]) rows[seat.rowNum] = [];
    rows[seat.rowNum].push(seat);
  });
  return Object.values(rows).map(row => row.sort((a, b) => a.colNum - b.colNum));
});

const viewSessionDetail = async (session) => {
  detailOrder.value = null;
  detailSession.value = session;
  const hallId = session.hall?.id || session.hallId;
  const sessionId = session.id;
  try {
    const res = await seatApi.getAvailable(hallId, sessionId);
    detailSeats.value = res.data || [];
    detailModalVisible.value = true;
  } catch (e) {
    console.error(e);
  }
};

const viewOrderDetail = async (order) => {
  detailOrder.value = order;
  try {
    const res = await adminApi.getOrderDetail(order.id);
    detailOrder.value = res.data;
    const sessionId = res.data.session?.id;
    const hallId = res.data.session?.hall?.id;
    if (sessionId && hallId) {
      const seatsRes = await seatApi.getAvailable(hallId, sessionId);
      orderAllSeats.value = seatsRes.data || [];
    }
  } catch (e) {
    console.error(e);
  }
  detailModalVisible.value = true;
};

const formatSeats = (seats) => {
  if (!seats || seats.length === 0) return '-';
  return seats.map(s => s.seatNo).join(', ');
};

const orderSeatGrid = computed(() => {
  const rows = {};
  const bookedSeats = detailOrder.value?.seats || [];
  const bookedSeatMap = {};
  bookedSeats.forEach(s => { bookedSeatMap[s.id] = s; });
  
  orderAllSeats.value.forEach(seat => {
    if (!rows[seat.rowNum]) rows[seat.rowNum] = [];
    const isBooked = !!bookedSeatMap[seat.id];
    rows[seat.rowNum].push({
      ...seat,
      isBooked: isBooked,
      bookedType: isBooked ? bookedSeatMap[seat.id].type : null
    });
  });
  return Object.values(rows).map(row => row.sort((a, b) => a.colNum - b.colNum));
});

const getOrderSeatClass = (seat) => {
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

const formatTime = (time) => {
  if (!time) return '-';
  return new Date(time).toLocaleString('zh-CN');
};

const getDetailSeatClass = (seat) => {
  if (seat.available === false) return 'sold';
  if (seat.type === 'VIP') return 'vip';
  if (seat.type === '情侣座') return 'couple';
  return 'available';
};

import { seatApi } from '../api';

const updateOrderStatus = async (id, status) => { await adminApi.updateOrderStatus(id, status); loadData(); };
const loadHallSeats = async () => { hallSeats.value = seatForm.hallId ? (await adminApi.getHallSeats(seatForm.hallId)).data : []; };
const updateSeatType = async (id, type) => { await adminApi.updateSeat(id, { type }); };

const seatGrid = computed(() => {
  const rows = {};
  const seats = seatTypeFilter.value ? hallSeats.value.filter(s => s.type === seatTypeFilter.value) : hallSeats.value;
  seats.forEach(seat => {
    if (!rows[seat.rowNum]) rows[seat.rowNum] = [];
    rows[seat.rowNum].push(seat);
  });
  return Object.values(rows).map(row => row.sort((a, b) => a.colNum - b.colNum));
});

const getSeatClass = (seat) => {
  if (seat.type === 'VIP') return 'vip';
  if (seat.type === '情侣座') return 'couple';
  return 'normal';
};

const toggleSeatType = async (seat) => {
  if (detailSession.value) {
    const canEdit = detailSession.value.status !== 'showing' && detailSession.value.status !== 'available' && (!detailSession.value.sold || detailSession.value.sold === 0);
    if (!canEdit) return;
  }
  const types = ['普通', 'VIP', '情侣座'];
  const currentIdx = types.indexOf(seat.type);
  const nextType = types[(currentIdx + 1) % types.length];
  seat.type = nextType;
  await updateSeatType(seat.id, nextType);
};

const canEditSeats = computed(() => {
  if (!detailSession.value) return false;
  return detailSession.value.status !== 'showing' && detailSession.value.status !== 'available' && (!detailSession.value.sold || detailSession.value.sold === 0);
});

const filterByType = (type) => { seatTypeFilter.value = type; };

const seatForm = reactive({ hallId: '' });
const selectedHallForSeats = ref(null);
const expandedHallId = ref(null);

const expandedHallName = computed(() => {
  const h = halls.value.find(x => x.id === expandedHallId.value);
  return h?.name || '';
});
const expandedHallRows = computed(() => {
  const h = halls.value.find(x => x.id === expandedHallId.value);
  return h?.rows || 8;
});
const expandedHallCols = computed(() => {
  const h = halls.value.find(x => x.id === expandedHallId.value);
  return h?.columns || 10;
});

const toggleHallSeats = async (hall) => {
  if (expandedHallId.value === hall.id) {
    expandedHallId.value = null;
    hallSeats.value = [];
  } else {
    expandedHallId.value = hall.id;
    hallSeats.value = (await adminApi.getHallSeats(hall.id)).data;
  }
};

onMounted(loadData);
</script>

<style scoped>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { background: #f5f5f5; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }

.admin-page { display: flex; min-height: calc(100vh - 52px); background: #0f0f0f; }

.sidebar { width: 180px; background: #141414; color: #fff; flex-shrink: 0; }
.logo { padding: 16px 20px; font-size: 14px; font-weight: 500; color: rgba(255,255,255,0.6); border-bottom: 1px solid rgba(255,255,255,0.08); }
.sidebar a { display: block; padding: 14px 20px; color: rgba(255,255,255,0.7); text-decoration: none; font-size: 14px; cursor: pointer; border-left: 3px solid transparent; transition: all 0.2s; }
.sidebar a:hover { background: rgba(255,255,255,0.1); color: #fff; }
.sidebar a.active { background: rgba(52,152,219,0.3); color: #fff; border-left-color: #3498db; }

.main { flex: 1; padding: 24px; overflow-x: auto; }
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-header h2 { font-size: 18px; font-weight: 500; color: #fff; }
.add-btn { padding: 10px 20px; background: #333; color: #fff; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; transition: background 0.2s; }
.add-btn:hover { background: #444; }

.panel { background: #1c1c1c; border-radius: 10px; padding: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.3); margin-bottom: 20px; }
table { width: 100%; border-collapse: collapse; }
th { text-align: left; padding: 14px 12px; color: rgba(255,255,255,0.5); font-weight: 500; font-size: 13px; border-bottom: 1px solid rgba(255,255,255,0.08); }
td { padding: 14px 12px; border-bottom: 1px solid rgba(255,255,255,0.08); font-size: 14px; color: rgba(255,255,255,0.8); text-align: left; }
tr:hover { background: #2a2a2a; }

.action-btn { cursor: pointer; font-size: 13px; color: #888; padding: 4px 8px; margin-right: 8px; }
.action-btn.edit { color: #4fc3f7; }
.action-btn.edit:hover { color: #29b6f6; text-decoration: underline; }
.action-btn.delete { color: #ef5350; }
.action-btn.delete:hover { color: #e53935; text-decoration: underline; }
.action-btn.ban { color: #ff9800; }
.action-btn.ban:hover { color: #ffa726; text-decoration: underline; }

.tag { padding: 8px 16px; background: #333; border-radius: 20px; font-size: 13px; color: #aaa; cursor: pointer; transition: all 0.2s; }
.tag:hover { background: #444; color: #ddd; }
.tag.active { background: #555; color: #fff; }

.file-input { margin-bottom: 10px; }
.file-input input { padding: 8px; background: #333; color: #fff; }
.preview-img { width: 100px; height: 140px; object-fit: cover; margin-top: 10px; border-radius: 4px; }

.seat-admin { padding: 20px; background: #141414; border-radius: 10px; margin-top: 20px; }
.screen-area { display: flex; justify-content: center; margin-bottom: 30px; }
.screen { width: 60%; height: 30px; background: rgba(255,255,255,0.08); border-radius: 50% 50% 0 0; display: flex; align-items: center; justify-content: center; color: rgba(255,255,255,0.3); font-size: 12px; letter-spacing: 4px; }
.seat-grid { display: flex; flex-direction: column; align-items: center; gap: 8px; margin-bottom: 20px; }
.seat-row { display: flex; align-items: center; gap: 8px; }
.row-label { width: 20px; color: rgba(255,255,255,0.4); font-size: 12px; }
.seats { display: flex; gap: 4px; }
.seat { width: 28px; height: 28px; border-radius: 6px 6px 3px 3px; cursor: pointer; transition: all 0.2s; }
.seat.normal { background: #4caf50; }
.seat.available { background: #4caf50; }
.seat.vip { background: #8e44ad; }
.seat.couple { background: #2980b9; width: 46px; }
.seat.sold { background: #2a2a2a; cursor: not-allowed; opacity: 0.5; }
.seat:hover { transform: scale(1.15); box-shadow: 0 0 8px rgba(255,255,255,0.3); }
.legend { display: flex; justify-content: center; gap: 20px; }
.legend-item { display: flex; align-items: center; gap: 6px; font-size: 13px; color: rgba(255,255,255,0.5); cursor: pointer; }
.legend-seat { width: 20px; height: 20px; border-radius: 4px; }
.legend-seat.normal { background: #4caf50; }
.legend-seat.available { background: #4caf50; }
.legend-seat.vip { background: #8e44ad; }
.legend-seat.couple { background: #2980b9; width: 32px; }
.legend-seat.sold { background: #2a2a2a; }

.modal-mask { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); display: flex; justify-content: center; align-items: center; z-index: 1000; backdrop-filter: blur(4px); overflow-y: auto; padding: 20px; }
.modal-box { background: #1c1c1c; border-radius: 12px; width: 420px; max-height: 80vh; overflow: hidden; box-shadow: 0 20px 60px rgba(0,0,0,0.5); display: flex; flex-direction: column; }
.modal-header { padding: 20px 24px; border-bottom: 1px solid rgba(255,255,255,0.08); font-size: 16px; font-weight: 600; color: #fff; flex-shrink: 0; }
.modal-body { padding: 24px; overflow-y: auto; flex: 1; }
.form-item { margin-bottom: 18px; }
.form-item label { display: block; font-size: 14px; color: rgba(255,255,255,0.6); margin-bottom: 8px; }
.form-item input, .form-item select, .form-item textarea { width: 100%; padding: 12px; border: 1px solid rgba(255,255,255,0.1); border-radius: 6px; font-size: 14px; background: #333; color: #fff; transition: border-color 0.2s; }
.form-item input:focus, .form-item select:focus, .form-item textarea:focus { outline: none; border-color: #555; }
.modal-footer { padding: 16px 24px; border-top: 1px solid rgba(255,255,255,0.08); display: flex; justify-content: flex-end; gap: 12px; }
.btn-confirm { padding: 10px 24px; background: #333; color: #fff; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: 500; transition: background 0.2s; }
.btn-confirm:hover { background: #444; }
.btn-cancel { padding: 10px 24px; background: transparent; color: rgba(255,255,255,0.6); border: 1px solid rgba(255,255,255,0.2); border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: 500; transition: all 0.2s; }
.btn-cancel:hover { background: rgba(255,255,255,0.1); }

.movie-detail-info { color: #ccc; }
.movie-detail-info .detail-row { margin-bottom: 12px; display: flex; }
.movie-detail-info .label { color: #888; width: 60px; flex-shrink: 0; }
.movie-detail-info .value { flex: 1; color: #fff; }

.order-seats-section { margin-top: 20px; }
.seats-title { color: #fff; font-size: 15px; margin-bottom: 15px; }
.seat.is-booked { box-shadow: 0 0 10px 3px rgba(229, 9, 20, 0.8); border: 2px solid #e50914; z-index: 1; }
.legend-seat.is-booked { box-shadow: 0 0 6px 2px rgba(229, 9, 20, 0.8); border: 2px solid #e50914; }
</style>