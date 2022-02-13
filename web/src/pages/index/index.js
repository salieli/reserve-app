import Vue from 'vue'
import App from './index.vue'
import '../../plugins/element.js'
import { UserManager, ContentManager, ReserveManager, PlaceManager, exec } from '@/common/function.js'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'

Vue.config.productionTip = false
Vue.prototype.$ReserveManager = ReserveManager;
Vue.prototype.$PlaceManager = PlaceManager;
Vue.prototype.$UserManager = UserManager;
Vue.prototype.$ContentManager = ContentManager;
Vue.prototype.$exec = exec;

new Vue({
    render: h => h(App),
}).$mount('#app')