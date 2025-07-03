import { createApp } from 'vue'
import App from './App.vue'

createApp(App).mount('#app')
// In your main.js or api.js
const API_BASE_URL = import.meta.env.VITE_API_URL || 'https://your-springboot-app.onrender.com/api/todos';

// Add request interceptors if using Axios
axios.interceptors.request.use(config => {
    config.headers['Content-Type'] = 'application/json';
    return config;
});
