<template>
    <div class="loginBody">
        <div class="loginDiv">
            <div class="login-left">
                <div class="left-title">
                    <img src="../assets/welcome.png" alt="welcome" class = "welcomeImag"/>
                    <h2>智能仓储系统</h2>
                </div>
                <div class="left-bottom">
                    <p>2024 © 文松出品</p>
                </div>
            </div>
            <div class="login-content">
                <el-row>
                    <el-col style="text-align: center; padding: 25px 0 25px 0">
                        <i
                            class="iconfont icon-r-building"
                            style="font-size: 36px"
                        ></i>
                        <b style="font-size: 35px; font-family: 'Noto Sans', sans-serif; font-weight: 500;"> 欢迎登录</b>
                    </el-col>
                </el-row>
                <el-form
                    :model="loginForm"
                    label-width="100px"
                    :rules="rules"
                    ref="loginForm"
                >
                    <el-form-item label="账号" v-if="loginType === 'account'" prop="no">
                        <el-input
                            style="width: 200px"
                            type="text"
                            v-model="loginForm.no"
                            autocomplete="off"
                            placeholder="请输入账号"
                        ></el-input>
                    </el-form-item>
                    <el-form-item label="密码" v-if="loginType === 'account'" prop="password">
                        <el-input
                            style="width: 200px"
                            type="password"
                            v-model="loginForm.password"
                            show-password
                            autocomplete="off"
                            @keyup.enter.native="confirm"
                            placeholder="请输入密码"
                        ></el-input>
                    </el-form-item>

                    <el-form-item label="手机号" v-if="loginType === 'phone'" prop="phone">
                        <el-input
                            style="width: 200px"
                            type="text"
                            v-model="loginForm.phone"
                            autocomplete="off"
                            placeholder="请输入手机号"
                        ></el-input>
                    </el-form-item>
                    <el-form-item label="验证码" v-if="loginType === 'phone'" prop="code">
                        <el-row>
                            <el-col :span="14">
                                <el-input
                                    style="width: 150px"
                                    type="text"
                                    v-model="loginForm.code"
                                    autocomplete="off"
                                    placeholder="点击右侧获取"
                                ></el-input>
                            </el-col>
                            <el-col :span="10">
                                <el-button @click="sendCode" style="margin-left: -26px" :disabled="code_disabled">{{ code_text }}</el-button>
                            </el-col>
                        </el-row>
                    </el-form-item>
                    <el-form-item style="padding-left: 45px">
                        <el-button
                            type="primary"
                            @click="confirm"
                            :disabled="confirm_disabled"
                            style="font-size: 20px"
                        >
                            登 录
                        </el-button>
                    </el-form-item>

                    <el-form-item style="text-align: center; margin-left: 130px">
                        <el-link @click="toggleLoginType">{{ loginType === 'account' ? '使用手机号登录' : '使用账号密码登录' }}</el-link>
                    </el-form-item>
                </el-form>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "Login",
    data() {
        return {
            loginType: 'account', // 登录类型：'account' 或 'phone'
            confirm_disabled: false, // 防止多次提交
            code_disabled: false, // 验证码按钮是否禁用
            code_text: '获取验证码',
            loginForm: {
                no: "",
                password: "",
                phone: "",
                code: ""
            },
            rules: {
                no: [
                    { required: true, message: "请输入账号", trigger: "blur" }
                ],
                password: [
                    { required: true, message: "请输密码", trigger: "blur" }
                ],
                phone: [
                    { required: true, message: "请输入手机号", trigger: "blur" }
                ],
                code: [
                    { required: true, message: "请输入验证码", trigger: "blur" }
                ]
            }
        };
    },
    methods: {
        toggleLoginType() {
            this.loginType = this.loginType === 'account' ? 'phone' : 'account';
        },
        sendCode() {
            if (this.loginForm.phone === '') {
                this.$message.error('请输入手机号');
                return;
            }
            this.code_disabled = true;
            this.code_text = '发送中...';
            // 调用发送验证码的接口
            this.$axios.post(this.$httpUrl + "/user/sendCode", { phone: this.loginForm.phone })
                .then((res) => res.data)
                .then((res) => {
                    if (res.code == 200) {
                        this.$message.success('验证码已发送');
                        this.startCodeTimer();
                    } else {
                        this.$message.error('发送验证码失败');
                        this.code_disabled = false;
                        this.code_text = '获取验证码';
                    }
                })
                .catch((e) => {
                    this.$message.error('发送验证码失败');
                    this.code_disabled = false;
                    this.code_text = '获取验证码';
                });
        },
        startCodeTimer() {
            let count = 60;
            const timer = setInterval(() => {
                if (count > 0) {
                    this.code_text = `${count--}秒后重试`;
                } else {
                    clearInterval(timer);
                    this.code_disabled = false;
                    this.code_text = '获取验证码';
                }
            }, 1000);
        },
        confirm() {
            this.confirm_disabled = true;
            this.$refs.loginForm.validate((valid) => {
                if (valid) {
                    if (this.loginType === 'account') {
                        this.loginWithPassword();
                    } else {
                        this.loginWithPhone();
                    }
                } else {
                    this.confirm_disabled = false;
                    return false;
                }
            });
        },
        loginWithPassword() {
            // 使用账号密码登录
            this.$axios.post(this.$httpUrl + "/user/login", this.loginForm)
                .then((res) => res.data)
                .then((res) => {
                    if (res.code == 200) {
                        sessionStorage.setItem("CurUser", JSON.stringify(res.data.user));
                        this.$store.commit("setMenu", res.data.menu);
                        this.$router.replace("/Index");
                    } else {
                        this.confirm_disabled = false;
                        this.$message.error("校验失败，用户名或密码错误！");
                    }
                })
                .catch((e) => {
                    this.confirm_disabled = false;
                    this.showError(e);
                });
        },
        loginWithPhone() {
            // 使用手机号和验证码登录
            this.$axios.post(this.$httpUrl + "/user/loginWithCode", this.loginForm)
                .then((res) => res.data)
                .then((res) => {
                    if (res.code == 200) {
                        sessionStorage.setItem("CurUser", JSON.stringify(res.data.user));
                        this.$store.commit("setMenu", res.data.menu);
                        this.$router.replace("/Index");
                    } else {
                        this.confirm_disabled = false;
                        this.$message.error("校验失败，手机号或验证码错误！");
                    }
                })
                .catch((e) => {
                    this.confirm_disabled = false;
                    this.showError(e);
                });
        },
        showError(e) {
            if (e.response == undefined || e.response.data == undefined) {
                this.$message({
                    showClose: true,
                    message: e,
                    type: "error",
                    duration: 5000
                });
            } else {
                this.$message({
                    showClose: true,
                    message: e.response.data,
                    type: "error",
                    duration: 5000
                });
            }
        }
    }
};
</script>

<style scoped>
html,
body {
    overflow-x: hidden;
}

.loginBody {
    position: absolute;
    width: 100%;
    height: 100%;
    background: url("../assets/home.png");
    background-size: 100% 100%;

    overflow-x: hidden;
}
.loginDiv {
    position: absolute;
    top: 50%;
    left: 50%;
    margin-top: -200px;
    margin-left: -320px;
    width: 640px;
    height: 330px;
    background: #ffffff;
    border-radius: 5%;
    opacity: 0.9;
}
 .login-left {
    display: flex;
    flex-direction: column;
    background-size: cover;
    width: 300px;
    height: 328px;
    flex-grow: 1;
 }
 .welcomeImag {
    height: 91px;
    width: 231px;
    border: none;
    margin: 0;
 }
.left-title {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 100%;
    margin-bottom: 10px;
    flex-grow: 3;
    color: #000000;
}
 .left-bottom {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 1px;
    flex-grow: 1;
    color: #000000;
}

.login-title {
    margin: 20px 0;
    text-align: center;
}
.login-content {
    width: 400px;
    height: 250px;
    position: absolute;
    top: 25px;
    left: 232px;
}
</style>
