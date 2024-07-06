<!--仓库管理系统首页组件-->
<template>
    <el-container style="height: 100%; border: 1px solid #eee; background-color:#F7FAF8;">
        <el-aside :width="aside_witdh" style="height: 100vh;background-color: rgb(238, 241, 246);margin-left: -1px;">
            <Aside :isCollapse="isCollapse"></Aside>
        </el-aside>

        <el-container style="height: 100%;">
            <el-header style="text-align: right; font-size: 12px;height: 100%;border-bottom: rgba(168,168,168,0.3) 1px solid;">
                <Header @doCollapse="doCollapse" :icon="icon"></Header>
            </el-header>

            <el-main style="height: 100%;">
               <!-- <Main></Main> -->
                <router-view/>
            </el-main>
        </el-container>
    </el-container>
</template>

<script>
    import Aside from "./Aside";
    import Header from "./Header";

    export default {
        name: "Index",
        components:{Aside,Header},
        data(){
            return {
                isCollapse:false,
                aside_witdh:'200px',
                icon:'iconfont icon-r-left'
            }
        },
        methods:{
            doCollapse(){
                console.log(1111)

                this.isCollapse = !this.isCollapse
                if(!this.isCollapse){
                    this.aside_witdh='200px'
                    this.icon='iconfont icon-r-left'
                }else{
                    this.aside_witdh='64px'
                    this.icon='iconfont icon-r-right'
                }
            }
        }
    }
</script>

<style scoped>
    .el-header {
        /**background-color: #B3C0D1;**/
        color: #333;
        line-height: 60px;
    }
    .el-main{
        padding: 5px;
    }
    .el-aside {
        color: #333;
    }
</style>