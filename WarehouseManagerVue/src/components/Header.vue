<!--头部组件-->
<template>
    <div style="display: flex; line-height: 60px;">
        <div style="margin-top: 15px">
            <!--菜单伸缩-->
            <i
                :class="icon"
                style="font-size: 30px; cursor: pointer;"
                @click="collapse"
            ></i>
        </div>
        <div style="flex: 1; text-align: center; font-size: 34px">
            
        </div>

        <el-row>
            <el-col :span="8">
                <el-avatar
                    shape="square"
                    :size="50"
                    :src="require('@/assets/avatar1.jpg')"
                    style="margin: 15px 5px -10px 0; border: 1px solid lightgrey"
                ></el-avatar>
            </el-col>
            <el-col :span="16" style="padding: 23px 0 0 0;">
                <el-dropdown style="cursor: pointer">
                    <!--dropdown下拉-->
                    <span style="font-size: 20px;">{{ user.name }}</span
                    ><i class="el-icon-arrow-down" style="margin-left: 5px"></i>
                    <el-dropdown-menu slot="dropdown">
                        <el-dropdown-item @click.native="toUser"
                            >个人中心</el-dropdown-item
                        >
                        <el-dropdown-item @click.native="logout"
                            >退出登录</el-dropdown-item
                        >
                    </el-dropdown-menu>
                </el-dropdown>
            </el-col>
        </el-row>
    </div>
</template>

<script>
export default {
    name: "Header",
    data() {
        return {
            user: JSON.parse(sessionStorage.getItem("CurUser")),
        };
    },
    props: {
        icon: String,
    },
    methods: {
        toUser() {
            this.$router.push("/Profile");
        },
        logout() {
            console.log("logout");

            this.$confirm("您确定要退出登录吗？", "提示", {
                confirmButtonText: "确定", //确认按钮的文字显示
                type: "warning",
                center: true, //文字居中显示
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
        collapse() {
            this.$emit("doCollapse");
        },
    },
    created() {
        this.$router.push("/Home");
    },
};
</script>

<style scoped>
</style>