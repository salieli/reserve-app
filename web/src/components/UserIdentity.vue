<template>
<span style="float: right;font-size: 1.1rem">
    <span style="color:#409EFF;font-weight:bold;" v-if="user.isStaff && !user.isSuperuser">(高级管理员)</span>
    <span style="color:#F56C6C;font-weight:bolder;" v-else-if="user.isStaff && user.isSuperuser">(超级管理员)</span>
</span>
</template>

<script>
export default {
    name: "UserIdentity",
    props: {
        user: Object
    },
};
</script>

<style scoped>

</style>
