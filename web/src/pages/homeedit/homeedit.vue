<template>
<div id="app">
    <el-container style="height:100%; border: 1px solid #eee">
        <el-header style="font-size: 12px;height:initial;border-bottom: 1px solid #ebebeb;">
            <HeaderBar />
        </el-header>
        <el-container style="height:calc(100% - 161px);">
            <el-aside style="background-color: rgb(238, 241, 246);overflow-x:hidden;">
                <LeftMenu :active="active" />
            </el-aside>
            <el-container>
                <el-main style="padding-top:20px;">
                    <Editor v-if="noticeData" :data="noticeData" />
                    <el-divider></el-divider>
                    <ImageContent v-if="imgData" :data="imgData" />
                </el-main>
            </el-container>
        </el-container>
    </el-container>
</div>
</template>

<script>
import HeaderBar from "@/components/HeaderBar.vue";
import LeftMenu from "@/components/LeftMenu.vue";
import Editor from "@/components/Editor.vue";
import ImageContent from "@/components/ImageContent.vue";

export default {
    name: "app",
    components: {
        HeaderBar,
        LeftMenu,
        Editor,
        ImageContent
    },
    data() {
        return {
            active: "2-4",
            list: [],
            noticeData: null,
            imgData: null,
        };
    },
    async mounted() {
        await this.getData();
    },
    methods: {
        async dataChange() {
            await this.getData();
        },
        async getNotice() {
            this.noticeData = (await this.$exec(async () => await this.$ContentManager.getAll(), false, false));
        },
        async getData() {
            let list = await this.$exec(async () => await this.$ContentManager.getAll());
            this.noticeData = list[0];
            list[1].content = (list[1].content.split("|")).map(v => {
                return {
                    url: v
                }
            });
            this.imgData = list[1];
        },
    }
};
</script>

<style>
.el-carousel {
    width: 800px;
}

.el-carousel__item h3 {
    color: #475669;
    font-size: 18px;
    opacity: 0.75;
    line-height: 300px;
    margin: 0;
}

.el-carousel__item:nth-child(2n) {
    background-color: #99a9bf;
}

.el-carousel__item:nth-child(2n+1) {
    background-color: #d3dce6;
}

.text {
    font-size: 14px;
}

.item {
    margin-bottom: 18px;
    cursor: pointer;
}

.clearfix:before,
.clearfix:after {
    display: table;
    content: "";
}

.clearfix:after {
    clear: both
}

.box-card {
    width: 480px;
}

html {
    height: 100vh;
}

@media only screen and (min-width: 550px) {
    html {
        font-size: 62.5% !important;
    }
}

@media only screen and (max-width: 550px) {
    html {
        font-size: 40% !important;
    }
}

body {
    font-family: "Avenir", Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    font-size: 1.4rem;
    margin: 0;
    height: 100%;
    overflow: hidden;
}

#app {
    width: 100%;
    height: 100%;
}

.img {
    width: 100%;
    height: 100%;
}

@media (max-width: 550px) {
    .el-aside {
        width: auto !important;
    }

    .el-main {
        padding: 0 10px 10px 10px !important;
    }

    .margin-bottom-item {
        margin-bottom: 10px;
    }
}

@media (min-width: 550px) {
    .el-aside {
        width: 200px !important;
    }

    .margin-bottom-item {
        margin-bottom: 20px;
    }
}
</style>
