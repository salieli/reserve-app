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
                <el-header style="font-size: 2rem;height:30px;margin-top:20px;">
                    预约记录<span class="text-md text-gray">[{{title}}]</span>
                    <UserIdentity :user="user" />
                </el-header>
                <el-main style="padding-top:10px;">
                    <ReserveView v-for="o in list" :key="o.id" :isStaff="user.isStaff" :data="o" class="margin-bottom-viewreserve" v-on:refresh="dataChange" />
                    <el-pagination :page-size="pageSize" :current-page="currentPage" :pager-count="5" layout="prev, pager, next" :total="total" small @current-change="getData">
                    </el-pagination>
                </el-main>
            </el-container>
        </el-container>
    </el-container>
</div>
</template>

<script>
import ReserveView from "@/components/ReserveView.vue";
import LeftMenu from "@/components/LeftMenu.vue";
import HeaderBar from "@/components/HeaderBar.vue";
import UserIdentity from "@/components/UserIdentity.vue";
import EventBus from '@/common/eventBus.js';
// import * as Fake from "@/common/fakeData.js";

export default {
    name: "app",
    components: {
        ReserveView,
        LeftMenu,
        HeaderBar,
        UserIdentity
    },
    data() {
        return {
            title: "",
            active: "",
            user: {},
            list: [],
            typeList: [
                "auditing",
                "passed",
                "rejected",
                "now",
                "historicalpassed",
                "historicalrejected",
            ],
            titleList: {
                auditing: "待审核",
                passed: "已通过",
                rejected: "已拒绝",
                now: "当前预约",
                historicalpassed: "历史通过",
                historicalrejected: "历史拒绝",
            },
            activeList: {
                auditing: "2-1-1",
                passed: "2-1-2",
                rejected: "2-1-3",
                now: "1-1",
                historicalpassed: "1-2",
                historicalrejected: "1-3",
            },
            total: 0,
            currentPage: 1,
            pageSize: 10
        };
    },
    created() {
        EventBus.$on('setUser', args => {
            this.user = args;
        })
    },
    async mounted() {

        let key = location.search.substr(1);
        if (this.typeList.indexOf(key) === -1) {
            window.location.href = "https://www.fcxmy.cn/njaureserve/";
        } else {
            this.title = this.titleList[key];
            this.active = this.activeList[key];
            this.dataType = key;

            await this.$exec(async () => {
                await this.getDataCount(false);
                await this.getData(1, false);
            });

            // this.total = 5;
            // this.list = Fake.reserveData();
        }
    },
    methods: {
        async dataChange() {
            this.currentPage = 1;
            await this.getData(1);
        },
        async getDataCount(loading = true) {
            this.total = (await this.$exec(async () =>
                await this.$ReserveManager.getReserveDataByType(this.dataType, {
                    count: true
                }), false, loading))[0][0];
        },
        async getData(pageNo, loading = true) {
            this.list = await this.$exec(async () =>
                await this.$ReserveManager.getReserveDataByType(this.dataType, {
                    pageNo: pageNo - 1,
                    pageSize: this.pageSize
                }), false, loading) || [];

            this.$message.success(
                this.list.length > 0 ? "数据获取成功" : "暂无数据"
            );
        }
    }

};
</script>

<style>
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
    height: 100%;
}

.el-pagination {
    text-align: center;
}

@media (max-width: 550px) {
    .el-aside {
        width: auto !important;
    }

    .el-main {
        padding: 0 10px 10px 10px !important;
    }

    .margin-bottom-viewreserve {
        margin-bottom: 10px;
    }
}

@media (min-width: 550px) {
    .el-aside {
        width: 200px !important;
    }

    .margin-bottom-viewreserve {
        margin-bottom: 20px;
    }
}
</style>
