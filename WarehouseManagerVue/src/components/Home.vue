<template>
    <div class="container">
        <div class="welcome">
            <b>
                <span> 欢迎使用智能仓储系统，</span>
                <span class="username">{{ user.name }}</span>
            </b>
        </div>

        <h5 class="role">
            <span class="role-label">您当前的角色是：</span>
            {{
                user.roleId == 0
                    ? "超级管理员"
                    : user.roleId == 1
                    ? "管理员"
                    : "用户"
            }}
        </h5>
        <DateUtils></DateUtils>
        <CurrentLocation></CurrentLocation>

        <div class="image-container">
            <img :src="require('@/assets/background.gif')" class="background-image" />
        </div>
    </div>
</template>

<script>
import DateUtils from "./DateUtils";
import CurrentLocation from "./CurrentLocation";

export default {
    name: "Home",
    components: { DateUtils, CurrentLocation },
    data() {
        return {
            user: {},
        };
    },
    methods: {
        init() {
            this.user = JSON.parse(sessionStorage.getItem("CurUser"));
        },
    },
    created() {
        this.init();
    },
};
</script>

<style scoped> 
.container {
    text-align: center;
    height: 559px;
    padding: 20px 0;
    margin: 0;
    background-color: rgb(247, 250, 248);
}

.welcome {
    font-size: 30px;
    color: grey;
    margin-bottom: 20px;
}

.username {
    color: rgb(111, 197, 217);
}

.role {
    font-size: 26px;
    color: rgb(136, 124, 124);
    margin-bottom: 20px;
}

.role-label {
    font-size: 22px;
}

.image-container {
    height: 55%;
    width: 55%;
    margin-left: 23%;
    margin-top: -30px;
    caret-color: transparent;
}

.background-image {
    height: 100%;
    width: 70%;
}
</style>
