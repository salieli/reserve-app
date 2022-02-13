import Vue from 'vue'
import App from './login.vue'
import '../../plugins/element.js'
import { UserManager, exec } from '@/common/function.js'

Vue.config.productionTip = false
Vue.prototype.$UserManager = UserManager;
Vue.prototype.$exec = exec;

new Vue({
    render: h => h(App),
}).$mount('#app')