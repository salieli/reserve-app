<template>
<div>
    <el-menu :default-active="active" class="el-menu-vertical-demo" :collapse="isCollapse">
        <el-menu-item index="-1" @click="navigateTo('/', false)">
            <i class="el-icon-s-home"></i>
            <span slot="title">主页</span>
        </el-menu-item>
        <el-menu-item index="0" @click="navigateTo('reserve', true)">
            <i class="el-icon-s-promotion"></i>
            <span slot="title">预约场地</span>
        </el-menu-item>
        <el-submenu index="1">
            <template slot="title">
                <i class="el-icon-s-order"></i>
                <span slot="title">预约记录</span>
            </template>
            <el-menu-item index="1-1" @click="navigateTo('viewreserve?now', false)">当前预约</el-menu-item>
            <el-menu-item index="1-2" @click="navigateTo('viewreserve?historicalpassed', false)">历史通过</el-menu-item>
            <el-menu-item index="1-3" @click="navigateTo('viewreserve?historicalrejected', false)">历史拒绝</el-menu-item>
        </el-submenu>
        <el-submenu index="2" v-if="user.isStaff">
            <template slot="title">
                <i class="el-icon-s-custom"></i>
                <span slot="title">管理员</span>
            </template>
            <el-submenu index="2-1">
                <template slot="title">预约管理</template>
                <el-menu-item index="2-1-1" @click="navigateTo('viewreserve?auditing', false)">待审核</el-menu-item>
                <el-menu-item index="2-1-2" @click="navigateTo('viewreserve?passed', false)">已通过</el-menu-item>
                <el-menu-item index="2-1-3" @click="navigateTo('viewreserve?rejected', false)">已拒绝</el-menu-item>
            </el-submenu>
            <el-menu-item index="2-2" @click="navigateTo('user', false)" v-if="user.isStaff">用户管理</el-menu-item>
            <el-menu-item index="2-3" @click="navigateTo('place', false)" v-if="user.isStaff">场地管理</el-menu-item>
            <el-menu-item index="2-4" @click="navigateTo('homeedit', false)" v-if="user.isStaff">首页管理</el-menu-item>
        </el-submenu>
        <el-submenu index="3">
            <template slot="title">
                <i class="el-icon-setting"></i>
                <span slot="title">设置</span>
            </template>
            <el-menu-item index="3-1" @click="dialogVisible = true">修改密码</el-menu-item>
            <el-menu-item index="3-2" @click="logout">注销登录</el-menu-item>
        </el-submenu>
    </el-menu>
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
import EventBus from '@/common/eventBus.js';
import * as config from '@/common/config.js';
// import * as Fake from "@/common/fakeData.js";

export default {
    name: "app",
    props: {
        active: String
    },
    components: {
    },

    data() {
        return {
            screenWidth: document.body.clientWidth,
            user: {},
            dev: false,
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
                }],
            },
            dialogVisible: false,
        };
    },
    computed: {
        isCollapse: {
            get() {
                return this.screenWidth < 550
            },
            set() {}
        },
    },
    watch: {
        screenWidth(val) {
            this.screenWidth = val;
            if (this.screenWidth < 550) {
                this.isCollapse = true;
            }
        }
    },
    async mounted() {



        window.onresize = () => {
            return (() => {
                this.screenWidth = document.body.clientWidth;
            })()
        }
        // this.user = Fake.user();
        this.user = await this.$exec(
            async () => await this.$UserManager.getUser()
        );
        EventBus.$emit('setUser', this.user);
    },
    methods: {
        navigateTo(url, open) {
            if (this.dev === false) {
                url = config.homeUrl + (url === "/" ? "" : url);
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
    }
};
</script>

<style>
@media (max-width: 550px) {
    .el-dialog {
        width: 90% !important;
    }
}
</style>
