import Vue from 'vue'
import App from './reserve.vue'
import '../../plugins/element.js'
import { ReserveManager, UserManager, PlaceManager, ReserveStatus, exec } from '@/common/function.js'

Vue.config.productionTip = false
Vue.prototype.$ReserveManager = ReserveManager;
Vue.prototype.$ReserveStatus = ReserveStatus;
Vue.prototype.$UserManager = UserManager;
Vue.prototype.$PlaceManager = PlaceManager;
Vue.prototype.$exec = exec;

new Vue({
    render: h => h(App),
}).$mount('#app')