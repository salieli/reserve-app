<template>
<div class="min-form-container">
    <div class="title">申请场地</div>
    <el-form :model="ruleForm" :rules="rules" label-width="100px" ref="ruleForm" class="min-form">
        <el-form-item prop="placeId" label="场地名称">
            <el-select v-model="ruleForm.placeId" placeholder="请选择场地" size="mini">
                <el-option v-for="o in placeList" :key="o" :label="o.name" :value="o.id"></el-option>
            </el-select>
        </el-form-item>

        <el-form-item label="使用日期" prop="usageDate">
            <el-date-picker type="date" placeholder="选择日期" value-format="yyyy-MM-dd" :picker-options="admin? '':pickerOptions" v-model="ruleForm.usageDate" size="mini" style="width: 100%"></el-date-picker>
        </el-form-item>

        <el-form-item prop="usageStartTime" label="开始时间">
            <el-time-select placeholder="选择开始时间" value-format="HH:mm:ss" v-model="ruleForm.usageStartTime" style="width: 100%" size="mini" :picker-options="{
                        start: '05:30',
                        step: '00:05',
                        end: '23:30',
                        maxTime: ruleForm.usageEndTime}"></el-time-select>
        </el-form-item>

        <el-form-item prop="usageEndTime" label="结束时间">
            <el-time-select placeholder="选择结束时间" value-format="HH:mm:ss" v-model="ruleForm.usageEndTime" style="width: 100%" size="mini" :picker-options="{
                        start: '05:30',
                        step: '00:05',
                        end: '23:59',
                        minTime: ruleForm.usageStartTime}"></el-time-select>
        </el-form-item>

        <el-form-item label="联系人" prop="contactManName">
            <el-input v-model="ruleForm.contactManName" size="mini"></el-input>
        </el-form-item>

        <el-form-item label="联系电话" prop="contactManTelephone">
            <el-input v-model="ruleForm.contactManTelephone" size="mini"></el-input>
        </el-form-item>

        <el-form-item label="申请理由" prop="usageReason">
            <el-input type="textarea" v-model="ruleForm.usageReason" size="mini"></el-input>
        </el-form-item>

        <el-form-item style="margin-top: 20px; width: 100%" label-width="0">
            <div class="btn-group">
                <div style="width:20px"></div>
                <el-button @click="resetForm('ruleForm')" size="mini">重置</el-button>
                <el-button @click="closeForm" type="danger" size="mini">关闭</el-button>
                <el-button type="primary" @click="submitForm('ruleForm')" size="mini">申请</el-button>
            </div>
        </el-form-item>
    </el-form>
</div>
</template>

<script>
import EventBus from '@/common/eventBus.js';

export default {
    props: {
        data: Object
    },
    data() {
        return {
            admin: false,
            pickerOptions: {
                disabledDate(time) {
                    const date = new Date();
                    date.setTime(date.getTime() + 3600 * 1000 * 24 * 14);
                    return time.getTime() < Date.now() || time.getTime() > date.getTime();
                },
            },
            ruleForm: {
                placeId: "",
                usageDate: "",
                usageStartTime: "",
                usageEndTime: "",
                usageReason: "",
                contactManName: "",
                contactManTelephone: ""
            },
            placeList: [],

            rules: {
                placeId: [{
                    required: true,
                    message: "请选择场地",
                    trigger: "change"
                }],
                region: [{
                    required: true,
                    message: "请选择活动区域",
                    trigger: "change"
                }, ],
                usageDate: [{
                    required: true,
                    message: "请选择日期",
                    trigger: "change",
                }, ],
                usageStartTime: [{
                    required: true,
                    message: "请选择开始时间",
                    trigger: "change",
                }, ],
                usageEndTime: [{
                    required: true,
                    message: "请选择结束时间",
                    trigger: "change",
                }],
                usageReason: [{
                    required: true,
                    message: "请输入理由",
                    trigger: "blur",
                }],
                contactManName: [{
                        required: true,
                        message: '请输入联系人姓名',
                        trigger: 'blur'
                    },
                    {
                        min: 2,
                        max: 10,
                        message: '长度2-10字符',
                        trigger: 'blur'
                    }
                ],
                contactManTelephone: [{
                    required: true,
                    message: '请输入联系人手机号码',
                    trigger: 'blur'
                }, {
                    pattern: /^1[3|4|5|7|8][0-9]{9}$/,
                    message: '手机号码的格式错误!',
                    trigger: 'blur'
                }]
            },
        };
    },
    async mounted() {
        let user = await this.$exec(
            async () => await this.$UserManager.getUser()
        );
        this.admin = user.isSuperuser;
        await this.getData();
    },

    methods: {
        async getData() {
            this.placeList = await this.$exec(async () => await this.$PlaceManager.getPlaceList()) || [];
        },
        async submitForm(formName) {
            this.$refs[formName].validate(async (valid) => {
                if (valid) {
                    let res = await this.$exec(
                        async () =>
                            await this.$ReserveManager.submitReserveData(this.ruleForm),
                            "提交申请成功"
                    );
                    if (res) {
                        EventBus.$emit('refresh', true);
                        this.resetForm(formName);
                    }
                } else {
                    console.log("error submit!!");
                    return false;
                }
            });
        },
        resetForm(formName) {
            this.$refs[formName].resetFields();
        },
        closeForm() {
            this.$emit("closeForm");
        },
    },
};
</script>

<style>
.min-form-container {
    width: 80%;
    padding: 20px;
    text-align: center;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 #b9afaf;
}

.min-form-container .min-form {
    width: 92%;
}

.el-textarea__inner {
    font-family: "微软雅黑";
}

.min-form-container .title {
    text-align: center;
    padding: 20px 0;
    font-size: 1.5rem;
    font-weight: bold;
}

input {
    cursor: pointer;
}

.min-form-container .min-form .el-select {
    width: 100%;
}

.min-form-container .min-form .el-form-item {
    margin-bottom: 15px;
}

.min-form-container .min-form .el-form-item__error {
    padding-top: 1px;
}

.min-form-container .min-form .btn-group {
    display: flex;
}

.min-form-container .min-form .btn-group .el-button {
    flex: 1;
}
</style>
