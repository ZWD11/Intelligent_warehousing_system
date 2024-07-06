<template>
  <div id="app">
     <router-view/>
  </div>
</template>

<script>

export default {
  name: 'App',
  components: {},
  //解决前端刷新页面路由丢失问题
  data(){
    return{
      user : JSON.parse(sessionStorage.getItem('CurUser'))
    }
  },
  watch:{
    '$store.state.menu':{
      handler(val,old){
        console.log(val)
        if(!old && this.user && this.user.no){
          this.$store.commit('setMenu',val)
        }
      },
      immediate: true
    }
  }
}
</script>

<style> 
#app {
    height: 100%;
}
</style>