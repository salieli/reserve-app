import Vue from 'vue'
import App from './homeedit.vue'
import '../../plugins/element.js'
import { exec, ContentManager, UserManager } from '@/common/function.js'
import VueQuillEditor from 'vue-quill-editor'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'

Vue.use(VueQuillEditor, {
    placeholder: '请输入内容',
})


Vue.config.productionTip = false
Vue.prototype.$exec = exec;
Vue.prototype.$ContentManager = ContentManager;
Vue.prototype.$UserManager = UserManager;

new Vue({
    render: h => h(App),
}).$mount('#app')