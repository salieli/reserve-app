<template>
<div class="header">
    <span v-if="user" class="header-title">{{user.name}}</span>
</div>
</template>

<script>
import EventBus from '@/common/eventBus.js';
export default {
    name: "app",
    components: {},
    data() {
        return {
            user: null
        };
    },
    created() {
        EventBus.$on('setUser', args => {
            this.user = args;
        })
    },
};
</script>

<style scoped>
@media (min-width: 550px) {
    .header-img {
        width: 50px;
        height: 50px;
        margin-left: 20px;
    }
}

@media (max-width: 550px) {
    .header-img {
        width: 50px;
        height: 50px;
        margin-right: 20px;
    }
}

.header {
    padding: 20px 0;
}

.header-title {
    float: right;
    height: 50px;
    letter-spacing: 0.1em;
    font-size: 12px;
    line-height: 50px;
}
</style>
