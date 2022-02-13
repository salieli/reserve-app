import Vue from 'vue'
import App from './place.vue'
import '../../plugins/element.js'
import { UserManager, PlaceManager, exec } from '@/common/function.js'

Vue.config.productionTip = false
Vue.prototype.$ObjectManager = PlaceManager;
Vue.prototype.$PlaceManager = PlaceManager;
Vue.prototype.$UserManager = UserManager;
Vue.prototype.$exec = exec;

new Vue({
    render: h => h(App),
}).$mount('#app')