<template>
<div>
    <div class="top-bar"></div>
    <div class="bottom-bar">
        <i class="el-icon-s-operation icon-menu text-white" @click="menuShow = true"></i>
        <i class="el-icon-s-home icon-menu text-white" @click="navigateTo('/', false)"></i>
    </div>
    <el-drawer :visible.sync="menuShow" direction="btt" :show-close="false" :withHeader="false">
        <div class="tool-title text-white text-lg">你好！{{ username }}</div>
        <div class="divider-horizontal"></div>
        <div class="item" v-if="isAdmin">
            <div class="item-title text-white">
                <span class="padding-sm">管理员</span>
            </div>
            <div class="item-item-title text-md text-white bottom-line" @click="navigateTo('viewreserve?auditing', false)">
                待审核
            </div>
            <div class="item-item-title text-md text-white bottom-line" @click="navigateTo('viewreserve?passed', false)">
                已通过
            </div>
            <div class="item-item-title text-md text-white bottom-line" @click="navigateTo('viewreserve?rejected', false)">
                已拒绝
            </div>
            <div class="item-item-title text-md text-white bottom-line" @click="navigateTo('user', true)">
                管理用户
            </div>
            <div class="item-item-title text-md text-white bottom-line" @click="navigateTo('place', true)">
                管理场地
            </div>
        </div>

        <div class="item">
            <div class="item-title text-white">
                <span class="padding-sm">预约记录</span>
            </div>
            <div class="item-item-title text-md text-white bottom-line" @click="navigateTo('viewreserve?now', false)">
                当前预约
            </div>
            <div class="item-item-title text-md text-white bottom-line" @click="navigateTo('viewreserve?historicalpassed', false)">
                历史通过
            </div>
            <div class="item-item-title text-md text-white bottom-line" @click="navigateTo('viewreserve?historicalrejected', false)">
                历史拒绝
            </div>
        </div>

        <div class="item">
            <div class="item-title text-white">
                <span class="padding-sm">设置</span>
            </div>
            <div class="item-item-title text-md text-white bottom-line" @click="dialogVisible = true">
                修改密码
            </div>
            <div class="item-item-title text-md text-white bottom-line" @click="logout">
                注销登录
            </div>
        </div>
    </el-drawer>

    <el-dialog title="修改密码" :visible.sync="dialogVisible">
        <el-form :model="form" :rules="rules" ref="form">
            <el-form-item label="原密码" required prop="oldPassword">
                <el-input v-model="form.oldPassword" autocomplete="off"></el-input>
            </el-form-item>
            <el-form-item label="新密码" required prop="newPassword">
                <el-input v-model="form.newPassword" autocomplete="off"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button @click="dialogVisible = false">取 消</el-button>
            <el-button type="primary" @click="submitForm('form')">确 定</el-button>
        </div>
    </el-dialog>
</div>
</template>

<script>
export default {
    name: "ToolBar",
    props: {
        target: String,
    },
    data() {
        return {
            dev: true,
            form: {
                oldPassword: "",
                newPassword: "",
            },
            rules: {
                oldPassword: [{
                    required: true,
                    message: "请输入原密码",
                    trigger: "blur"
                }, ],
                newPassword: [{
                    required: true,
                    message: "请输入新密码",
                    trigger: "blur"
                }, ],
            },
            menuShow: false,
            list: [],
            username: "用户",
            isAdmin: false,
            dialogVisible: false,
        };
    },
    async mounted() {
        let res = await this.$exec(async () => await this.$UserManager.getUser());
        this.username = res.name;
        this.isAdmin = res.isStaff;
    },
    methods: {
        navigateTo(url, open) {
            if (this.dev === false) {
                url = "https://www.fcxmy.cn/njaureserve/" + (url === "/" ? "" : url);
            }
            if (open) {
                window.open(url);
            } else {
                window.location.href = url;
            }
        },
        async logout() {
            let res = await this.$exec(
                async () => await this.$UserManager.logout(),
            );

            if (res) {
                this.navigateTo("/");
            }
        },
        async submitForm(formName) {
            console.log(this.form);
            this.$refs[formName].validate(async (valid) => {
                if (valid) {
                    let res = await this.$exec(
                        async () =>
                            await this.$UserManager.changePassword(
                                this.form.oldPassword,
                                this.form.newPassword
                            ),
                            "修改密码成功"
                    );
                    if (res) {
                        this.navigateTo("/");
                    }
                } else {
                    console.log("error submit!!");
                    return false;
                }
            });
        },
    },
};
</script>

<style>
@media (min-width: 550px) {
    .el-drawer.btt {
        bottom: 42px !important;
        left: 20px !important;
        width: 400px !important;
        height: 730px !important;
        padding: 30px;
        background-color: #a63411b0 !important;
    }

    .text-lg {
        font-size: 3rem;
        color: #803319;
    }

    .text-md {
        font-size: 1.5rem;
    }

    .item-item-title {
        padding: 10px;
    }

    .divider-horizontal {
        margin: 24px 0;
    }
}

@media (max-width: 550px) {
    .el-drawer.btt {
        bottom: 42px !important;
        left: 0 !important;
        width: 50% !important;
        height: 88% !important;
        padding: 15px 10px;
        background-color: #a63411b0 !important;
    }

    .text-lg {
        font-size: 1.5rem;
        color: #803319;
    }

    .text-md {
        font-size: 1rem;
    }

    .item-item-title {
        padding: 8px;
    }

    .divider-horizontal {
        margin: 12px 0;
    }

    .el-dialog {
        width: 90% !important;
    }
}

.divider-horizontal {
    display: block;
    height: 1px;
    width: 100%;
    background-color: #dcdfe6;
}

.top-bar {
    position: fixed;
    top: 0;
    width: 100%;
    height: 20px;
    background-color: #a62a00;
    box-shadow: 0 -1px 1px 2px #cc7266;
    z-index: 9999;
}

.bottom-bar {
    position: fixed;
    bottom: 0;
    width: 100%;
    height: 40px;
    background-color: #a62a00;
    box-shadow: 0 -1px 1px 2px #cc7266;
    z-index: 9999;
}

.icon-menu {
    margin-left: 20px;
    line-height: 40px !important;
    font-size: 2.4rem;
    cursor: pointer;
}

.el-drawer:focus {
    outline: none !important;
}

.text-white {
    color: #fff;
}

.padding-sm {
    padding: 5px 0;
}

.tool-title {
    width: 100%;
    text-align: center;
}

.item {
    margin-bottom: 20px;
}

.bottom-line {
    border-bottom: 1px solid #fff;
}

.item-item-title {
    cursor: pointer;
}

.item-item-title:hover {
    background-color: #e6c3b870;
}
</style>
