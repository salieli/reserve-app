<template>
<div class="ql-snow">
    <div v-html="data" class="ql-editor"></div>
</div>
</template>

<script>
export default {
    props: {
        data: String,
    }
}
</script>

<style scoped>

</style>
