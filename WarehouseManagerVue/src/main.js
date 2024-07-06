import Vue from 'vue'
import App from './App.vue'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import './assets/global.css';
import './assets/font2/iconfont.css'
import axios from "axios";
import VueRouter from 'vue-router';
import './assets/font/iconfont.css'
import router from './router';
import store from './store';
import './store/initialize';
Vue.prototype.$axios=axios;
Vue.prototype.$httpUrl='http://localhost:9131'  //将地址设置为全局
Vue.config.productionTip = false
//Vue.use(ElementUI);
Vue.use(VueRouter);
Vue.use(ElementUI,{size:'small'});
new Vue({
  router,
  store,
  render: h => h(App),
}).$mount('#app')