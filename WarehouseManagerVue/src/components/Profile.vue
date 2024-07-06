<template>
    <div
        style="
            text-align: center;
            height: 100%;
            padding: 20px 0 0 0;
            margin: 0px;
        "
    >
    <!-- <div class="userInfo">
        <b> 我的账户</b>
    </div> -->
        
        <el-descriptions
            title=""
            :column="1"
            size="40"
            border
            style="padding: 20px 0 20px 0"
        >
            <el-descriptions-item>
                <template slot="label">
                    <i class="el-icon-s-custom"></i>
                    账号
                </template>
                <el-tag type="info">{{ user.no }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item>
                <template slot="label">
                    <i class="el-icon-user"></i>
                    姓名
                </template>
                <el-tag type="info">{{ user.name }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item>
                <template slot="label">
                    <i class="el-icon-lock"></i>
                    密码
                </template>
                <el-tag type="info">{{ user.password }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item>
                <template slot="label">
                    <i class="el-icon-date"></i>
                    年龄
                </template>
                <el-tag type="info">{{ user.age }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item>
                <template slot="label">
                    <i class="el-icon-mobile-phone"></i>
                    电话
                </template>
                <el-tag type="info">{{ user.phone }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item>
                <template slot="label">
                    <i class="el-icon-location-outline"></i>
                    性别
                </template>
                <el-tag
                    :type="user.sex == 1 ? 'primary' : 'danger'"
                    disable-transitions
                    ><i
                        :class="
                            user.sex == 1 ? 'el-icon-male' : 'el-icon-female'
                        "
                    ></i
                    >{{ user.sex == 1 ? "男" : "女" }}</el-tag
                >
            </el-descriptions-item>
            <el-descriptions-item>
                <template slot="label">
                    <i class="iconfont icon-r-mark1"></i>
                    角色
                </template>
                <el-tag type="success" disable-transitions>{{
                    user.roleId == 0
                        ? "超级管理员"
                        : user.roleId == 1
                        ? "管理员"
                        : "用户"
                }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item>
                <template slot="label">
                    <i class="el-icon-location"></i>
                    登录位置
                </template>
                <el-tag type="info">{{ user.location }}</el-tag>
            </el-descriptions-item>
        </el-descriptions>
        <hr />
        <el-row>
            <el-button
                type="danger"
                @click="logout"
                style="margin-top: 25px; font-size: 22px;"
                >
                 退出登录</el-button
            >
            <el-button
                type="success"
                @click="mod"
                style="margin-left: 72%; font-size: 22px;"
                >
                编辑</el-button>
        </el-row>
        <el-dialog
            title="提示"
            :visible.sync="centerDialogVisible"
            width="30%"
            center
        >
            <el-form ref="form" :rules="rules" :model="user" label-width="80px">
                <el-form-item label="账号" prop="no">
                    <el-col :span="20">
                        <el-input v-model="user.no"></el-input>
                    </el-col>
                </el-form-item>
                <el-form-item label="名字" prop="name">
                    <el-col :span="20">
                        <el-input v-model="user.name"></el-input>
                    </el-col>
                </el-form-item>
                <el-form-item label="密码" prop="password">
                    <el-col :span="20">
                        <el-input type="password" v-model="user.password"></el-input>
                    </el-col>
                </el-form-item>
                <el-form-item label="年龄" prop="age">
                    <el-col :span="20">
                        <el-input v-model="user.age"></el-input>
                    </el-col>
                </el-form-item>
                <el-form-item label="性别">
                    <el-radio-group v-model="user.sex">
                        <el-radio label="1">男</el-radio>
                        <el-radio label="0">女</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="电话" prop="phone">
                    <el-col :span="20">
                        <el-input v-model="user.phone"></el-input>
                    </el-col>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button
                    @click="cancel"
                    style="font-size: 18px;"
                >
                    取消</el-button
                >
                <el-button type="primary" @click="save" style="font-size: 18px;">
                    确定
                </el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
import CurrentLocation from './CurrentLocation.vue';

export default {
    name: "Home",
    components: {
        CurrentLocation
    },
    data() {
        let checkAge = (rule, value, callback) => {
            if (value > 100) {
                callback(new Error("年龄输入过大"));
            } else {
                callback();
            }
        };
        let checkDuplicate = (rule, value, callback) => {
            if (this.user.id) {
                return callback();
            }
            this.$axios
                .get(this.$httpUrl + "/user/findByNo?no=" + this.user.no)
                .then((res) => res.data)
                .then((res) => {
                    if (res.code != 200) {
                        callback();
                    } else {
                        callback(new Error("账号已经存在"));
                    }
                });
        };
        let checkPhoneDuplicate = (rule, value, callback) => {
            if (this.user.id) {
                return callback();
            }
            this.$axios
                .get(this.$httpUrl + "/user/findByPhone?phone=" + this.user.phone)
                .then((res) => res.data)
                .then((res) => {
                    if (res.code != 200) {
                        callback();
                    } else {
                        callback(new Error("电话号码已经存在"));
                    }
                });
        };
        
        return {
            user: {},
            centerDialogVisible: false,
            rules: {
                no: [
                    { required: true, message: "请输入账号", trigger: "blur" },
                    {
                        min: 3,
                        max: 8,
                        message: "长度在 3 到 8 个字符",
                        trigger: "blur",
                    },
                    { validator: checkDuplicate, trigger: "blur" },
                ],
                name: [
                    { required: true, message: "请输入名字", trigger: "blur" },
                ],
                password: [
                    { required: true, message: "请输入密码", trigger: "blur" },
                    {
                        min: 3,
                        max: 8,
                        message: "长度在 3 到 8 个字符",
                        trigger: "blur",
                    },
                ],
                age: [
                    { required: true, message: "请输入年龄", trigger: "blur" },
                    {
                        pattern: /^([1-9][0-9]*){1,3}$/,
                        message: "年龄必须为正整数字",
                        trigger: "blur",
                    },
                    { validator: checkAge, trigger: "blur" },
                ],
                phone: [
                    {
                        required: true,
                        message: "手机号不能为空",
                        trigger: "blur",
                    },
                    {
                        pattern: /^1[3|4|5|6|7|8|9][0-9]\d{8}$/,
                        message: "请输入正确的手机号码",
                        trigger: "blur",
                    },
                    { validator: checkPhoneDuplicate, trigger: "blur" },
                ],
            },
        };
    },
    computed: {},
    methods: {
        init() {
            this.user = JSON.parse(sessionStorage.getItem("CurUser"));
            this.user.location = sessionStorage.getItem("UserLocation");
        },
        cancel() {
            this.centerDialogVisible = false;
            this.init();
        },
        logout() {
            this.$confirm("您确定要退出登录吗？", "提示", {
                confirmButtonText: "确定", 
                type: "warning",
                center: true, 
            })
                .then(() => {
                    this.$message({
                        type: "success",
                        message: "退出登录成功！",
                    });

                    this.$router.push("/");
                    sessionStorage.clear();
                })
                .catch(() => {
                    this.$message({
                        type: "info",
                        message: "已取消退出登录！",
                    });
                });
        },
        mod() {
            this.centerDialogVisible = true;
        },
        doSave() {
            this.$axios
                .post(this.$httpUrl + "/user/save", this.user)
                .then((res) => res.data)
                .then((res) => {
                    console.log(res);
                    if (res.code == 200) {
                        this.$message({
                            message: "操作成功！",
                            type: "success",
                        });
                        sessionStorage.setItem("CurUser",JSON.stringify(this.user));
                        this.centerDialogVisible = false;
                        this.init();
                    } else {
                        this.$message({
                            message: "操作失败！",
                            type: "error",
                        });
                    }
                });
        },
        doMod() {
            this.$axios
                .post(this.$httpUrl + "/user/update", this.user)
                .then((res) => res.data)
                .then((res) => {
                    console.log(res);
                    if (res.code == 200) {
                        this.$message({
                            message: "操作成功！",
                            type: "success",
                        });
                        sessionStorage.setItem("CurUser",JSON.stringify(this.user));
                        this.centerDialogVisible = false;
                        this.init();
                    } else {
                        this.$message({
                            message: "操作失败，请检查账号或者手机号是否被使用！",
                            type: "error",
                        });
                    }
                });
        },
        save() {
            this.$refs.form.validate((valid) => {
                if (valid) {
                    if (this.user.id) {
                        this.doMod();
                    } else {
                        this.doSave();
                    }
                } else {
                    console.log("error submit!!");
                    return false;
                }
            });
        },
    },
    created() {
        this.init();
    },
};
</script>

<style scoped>
.el-descriptions {
    width: 90%;
    margin: 0 auto;
    text-align: center;
}

.userInfo {
    font-size: 32px;
}
</style>