<template>
<div>
    <el-card class="box-card">
        <span style="font-weight: bolder; width: 200px; display: inline-block">{{
        data.name
      }}</span>
        <span v-if="data.isStaff" style="color: #409EFF;font-weight:bold;">管理员</span>
        <span v-else-if="isUser" style="color: #909399;">普通用户</span>
        <span v-else-if="data.addBy" style="color:#F56C6C;">{{data.addBy}}<span style="color: #909399;">添加</span></span>
        <span v-if="isUser && data.placeNameList.length > 0" style="color: #909399">({{data.placeNameList.join("、")}})</span>
        <div class="operation">
            <el-button v-if="user && (user.isSuperuser || !data.isStaff)" style="
            float: right;
            padding: 3px 0;
            margin-left: 10px;
            color: #409eff;
          " type="text" @click="resetPassword">重置密码</el-button>
            <el-button v-if="user && (user.isSuperuser || !data.isStaff)" style="float: right; padding: 3px 0; color: #e6a23c" type="text" @click="showAuthorizeDialog">授权</el-button>
            <el-button v-if="!user || user.isSuperuser || !data.isStaff" style="float: right; padding: 3px 0; color: red" type="text" @click="deleteTarget">删除</el-button>
        </div>
    </el-card>
</div>
</template>

<script>
export default {
    name: "ManagerItem",
    components: {},
    props: {
        isUser: Boolean,
        user: Object,
        data: Object,
    },
    methods: {
        async deleteTarget() {
            this.$confirm("此操作将永久删除, 是否继续?", "提示", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning",
                })
                .then(async () => {
                    let res = await this.$exec(
                        async () => await this.$ObjectManager.delete(this.data.id),
                            "删除成功"
                    );

                    if (res) {
                        this.$emit("refresh");
                    }
                })
                .catch(() => {});
        },
        async resetPassword() {
            this.$confirm("此操作将重置密码为123456, 是否继续?", "提示", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning",
                })
                .then(async () => {
                    await this.$exec(
                        async () => await this.$ObjectManager.resetUserPassword(this.data.id),
                            "重置密码成功"
                    );
                })
                .catch(() => {});
        },
        showAuthorizeDialog() {
            this.$emit("showAuthorizeDialog", this.data);
        },

    },
};
</script>

<style>
@media (min-width: 550px) {
    .el-button {
        width: 70px;
        padding: 12px 10px;
    }

    .right {
        margin-right: 20px;
    }

    .operation {
        float: right;
    }
}

@media (max-width: 550px) {
    .operation {
        padding: 5px 0;
    }

    .el-button {
        padding: 12px 10px;
        font-size: 1rem;
    }

    .el-message-box {
        width: 250px !important;
    }

    .el-message {
        min-width: 0;
        width: 100%;
    }

    .el-dialog {
        width: 90%;
    }
}
</style>
