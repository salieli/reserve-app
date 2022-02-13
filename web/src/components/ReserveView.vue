<template>
<div>
    <el-card class="box-card">
        <div slot="header" class="clearfix">
            <span style="font-weight:bolder">{{ data.place }} <span style="margin-left: 10px;color:#409EFF;">{{ data.usageDate }} {{ data.usageStartTime }}~{{ data.usageEndTime }}</span></span>
            <div class="operation">
                <el-button v-if="isStaff && data.status === 0" style="float: right;padding: 3px 0;color:#67C23A;" type="text" @click="pass()">通过申请</el-button>
                <el-button v-if="isStaff && data.status === 1" style="float: right;padding: 3px 0;color:#F56C6C;margin-left: 10px;" type="text" @click="cancelPassed()">撤销通过</el-button>
                <el-button v-if="isStaff && data.status === 0" style="float: right;padding: 3px 0; margin-right: 10px;color:red;" type="text" @click="reject()">拒绝申请</el-button>
                <el-button v-if="!isStaff && data.status === 0" style="float: right;padding: 3px 0; margin-right: 10px;color:#F56C6C;" type="text" @click="cancel()">取消申请</el-button>
                <span class="text-redgray" v-if="!isStaff && data.status === 0">(待审核)</span>
                <span class="text-greenyellow" v-if="data.status === 1">已通过</span>
                <span class="text-red" v-if="data.status === 2">已拒绝</span>
            </div>

        </div>
        <div class="text item">
            <div style="display:flex;justify-content:space-between;">
                <span style="color:gray;">{{ data.username }} <span style="color:gray;">{{ data.reserveTime }}</span></span>
                <span style="color:gray;"> {{ data.contactManName }} {{ data.contactManTelephone }}</span>
            </div>
            <div style="margin-top: 10px;"> {{ data.usageReason }}</div>
        </div>
    </el-card>
</div>
</template>

<script>
export default {
    name: "ReserveView",
    props: {
        data: Object,
        isStaff: Boolean
    },
    methods: {
        async pass() {
            this.$confirm("确定通过申请?", "提示", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning",
                })
                .then(async () => {
                    let res = await this.$exec(
                        async () =>
                            await this.$ReserveManager.updateReserveStatus(
                                this.data.id,
                                this.$ReserveStatus.PASSED
                            ),
                            "操作成功"
                    );
                    if (res) {
                        this.$emit("refresh");
                    }
                })
                .catch(() => {});
        },
        async reject() {
            this.$confirm("确定拒绝申请?", "提示", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning",
                })
                .then(async () => {
                    let res = await this.$exec(
                        async () =>
                            await this.$ReserveManager.updateReserveStatus(
                                this.data.id,
                                this.$ReserveStatus.REJECTED
                            ),
                            "操作成功"
                    );

                    if (res) {
                        this.$emit("refresh");
                    }
                })
                .catch(() => {});
        },
        async cancel() {
            this.$confirm("确定取消申请?", "提示", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning",
                })
                .then(async () => {
                    let res = await this.$exec(
                        async () =>
                            await this.$ReserveManager.updateReserveStatus(
                                this.data.id,
                                this.$ReserveStatus.CANCELLED
                            ),
                            "操作成功"
                    );

                    if (res) {
                        this.$emit("refresh");
                    }
                })
                .catch(() => {});
        },
        async cancelPassed() {
            await this.reject();
        },
    },
};
</script>

<style>
@media (min-width: 550px) {

    .reserve-header {
        padding: 5px 20px;
        line-height: 40px;
    }

    .float-right {
        margin-left: 20px;
    }

    .text-md {
        font-size: 1.6rem;
    }

    .reserve-reason {
        padding: 20px;
        position: relative;
    }

    .text-bg {
        font-size: 3rem;
    }

    .operation {
        float: right;
    }

}

@media (max-width: 550px) {
    .operation {
        padding: 5px 0;
    }

    .float-right {
        margin-left: 5px;
    }

    .reserve-header {
        padding: 5px 5px;
        line-height: 25px;
    }

    .el-button {
        font-size: 0.3rem !important;
    }

    .el-message-box {
        width: auto !important;
    }

    .text-md {
        font-size: 1.3rem;
    }

    .icon {
        position: absolute;
    }

    .text-bg {
        font-size: 2rem;
    }

    .reserve-reason {
        padding: 5px;
        position: relative;
    }
}

.text-llg {
    font-size: 2.4rem;
}

.text-red {
    color: #dd1010;
}

.text-redgray {
    color: #882424;
}

.text-greenyellow {
    color: rgb(114, 187, 4);
}

.text-gray {
    color: gray;
}

.reserve-item {
    border-radius: 3px;
    margin-bottom: 20px;
}

.bg-red {
    box-shadow: 0 0 1px 2px #e63a00;
}

.bg-red>.reserve-header {
    background-color: #e63a00;
}

.bg-gray {
    box-shadow: 0 0 1px 2px #ccbdb8;
}

.bg-gray>.reserve-header {
    background-color: #ccbdb8;
}

.reserve-header {
    color: #000;
}

.float-right {
    float: right;
}

.reserve-btn {
    padding: 10px;
    text-align: right;
}

.box-header {
    padding-bottom: 18px;
    border-bottom: 1px solid #ebeef5;
    box-sizing: border-box;
}

.text-view {
    position: absolute;
    top: 50%;
    right: 15px;
    transform: translateY(-50%);
    font-weight: bold;
}
</style>
