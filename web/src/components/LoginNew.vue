<template>
<div style="height: 100%">
    <div class="container">
        <div class="form blue">
            <div class="form-title show-0 text">用户登录</div>
            <div class="form-title show-1 text">场地预约 | 用户登录</div>
            <div class="line"></div>

            <div class="form-box">
                <input class="form-item bg-grey-0 radius border" type="text" placeholder="用户名" name="username" v-model="username" />
            </div>
            <div class="form-box">
                <input class="form-item bg-grey-0 radius border" type="password" placeholder="密码" name="password" v-model="password" />
            </div>
            <div class="form-box">
                <button class="bg-darkred form-item submit-btn radius border" @click="login">
                    登录
                </button>
            </div>
        </div>
    </div>
</div>
</template>

<script>
export default {
    name: "Login",
    data() {
        return {
            username: "",
            password: "",
        };
    },

    methods: {
        async login() {
            let res = await this.$exec(
                async () => await this.$UserManager.login(this.username, this.password)
            );
            if (res) {
                window.location.reload();
            }
        }
    },
};
</script>

<style scoped>
.bg-darkred {
    background-color: #409eff;
}

.bg-grey-0 {
    background-color: #bfbfbf08;
}

.text-darkred {
    color: #409eff;
}

.radius {
    border-radius: 3px;
}

.form-title {
    font-size: 1.4rem;
}

.form {
    background-color: #FFF;
    opacity: 0.85;
}

@media (min-width: 800px) {
    .header {
        display: flex;
        width: 100%;
    }

    .show {
        display: flex;
        justify-content: start;
        align-items: center;
    }

    .form {
        padding: 20px;
        height: 240px;
        width: 400px;
        position: absolute;
        top: 20%;
        right: 10%;
        border: 1px solid #EBEEF5;
        box-shadow: 0 2px 12px 0 rgb(0 0 0 / 10%);
    }

    .show-0 {
        display: block;
    }

    .show-1 {
        display: none;
    }

    .form-item {
        height: 45px;
        line-height: 45px;
        font-size: 1rem;
    }

    .form-box {
        padding: 10px;
    }
}

@media (max-width: 800px) {
    .header {
        width: 100%;
    }

    .show {
        display: none;
    }

    .form {
        padding: 20px;
        transform: translateY(-100px);
    }

    .show-0 {
        display: none;
    }

    .show-1 {
        display: block;
    }

    .form-item {
        height: 33px;
        line-height: 33px;
        font-size: 1rem;
    }

    .form-box {
        padding: 5px;
    }

    .container {
        display: flex;
        justify-content: center;
        align-items: center;
    }

}

.header-bg {
    width: 100%;
    height: 10px;
}

.header-icon {
    max-width: 100%;
    height: auto;
}

.header-title {
    width: 100%;
}

.header-title-line {
    width: 2px;
    height: 80%;
    margin-right: 15px;
    background-color: #409eff;
}

.header-title-text {
    font-size: 3rem;
    font-family: "Microsoft YaHei";
}

/*主体部分*/

.container {
    background-image: url("~@/assets/background.jpg");
    background-repeat: no-repeat;
    background-attachment: fixed;
    background-position: center center;
    width: 100%;
    height: 100%;
}

.line {
    width: 100%;
    margin: 10px auto;
    height: 1px;
    background-color: white;
}

.form-title {
    color: #076bcf;
    font-weight: bold;
    text-indent: 20px;
}

.form-item {
    width: 100%;
    margin-top: 0;
    background-image: none;
    border-radius: 4px;
    box-sizing: border-box;
    color: #409eff;
    border: 1px solid #409eff;
    display: inline-block;
    outline: 0;
    padding: 0 15px;
    transition: border-color 0.2s cubic-bezier(0.645, 0.045, 0.355, 1);
}

.white .border {
    border: 1px solid #fff;
}

.white .text {
    color: #fff;
}

.blue .text {
    color: #409eff;
}

input:focus {
    border: #409eff solid 2px;
}

.submit-btn {
    white-space: nowrap;
    cursor: pointer;
    color: #ffffff;
    -webkit-appearance: none;
    text-align: center;
    box-sizing: border-box;
    border: none;
    outline: none;
    margin: 0;
    transition: 0.1s;
    font-weight: 500;
}

input::-webkit-input-placeholder {
    color: #409eff;
    opacity: 0.6;
}

input:-moz-placeholder {
    color: #409eff;
    opacity: 0.6;
}

input::-moz-placeholder {
    color: #409eff;
    opacity: 0.6;
}

input:-ms-input-placeholder {
    color: #409eff;
    opacity: 0.6;
}
</style>
