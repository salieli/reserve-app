import Vue from 'vue'
import App from './user.vue'
import '../../plugins/element.js'
import { UserManager, PlaceManager, exec } from '@/common/function.js'

Vue.config.productionTip = false
Vue.prototype.$ObjectManager = UserManager;
Vue.prototype.$UserManager = UserManager;
Vue.prototype.$PlaceManager = PlaceManager;
Vue.prototype.$exec = exec;


new Vue({
    render: h => h(App),
}).$mount('#app')