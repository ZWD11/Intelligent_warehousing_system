<template>
    <div style="line-height:1.75">
        <span>当前登录位置信息：
            <template v-if="loading">
                加载中 <i class="el-icon-loading"></i>
            </template>
            <template v-else>
                <br>{{ location }}
            </template>
        </span>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: "CurrentLocation",
    data() {
        return {
            loading: true,
            location: ''
        };
    },
    methods: {
        getCurrentLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        const latitude = position.coords.latitude;
                        const longitude = position.coords.longitude;
                        this.reverseGeocode(latitude, longitude);
                    },
                    (error) => {
                        switch (error.code) {
                            case error.PERMISSION_DENIED:
                                this.location = '用户拒绝了地理位置请求。';
                                break;
                            case error.POSITION_UNAVAILABLE:
                                this.location = '位置信息不可用。';
                                break;
                            case error.TIMEOUT:
                                this.location = '请求获取用户位置超时。';
                                break;
                            default:
                                this.location = '获取位置信息时发生未知错误。';
                                break;
                        }
                        console.error(error);
                    }
                );
            } else {
                this.location = '浏览器不支持地理位置获取';
            }
        },
        reverseGeocode(latitude, longitude) {
            const apiKey = 'c5a837c07c4441eab343f3be1212f06a'; 
            const apiUrl = `https://api.opencagedata.com/geocode/v1/json?q=${latitude}+${longitude}&key=${apiKey}&language=zh-CN`;

            axios.get(apiUrl)
                .then(response => {
                    const results = response.data.results;
                    if (results && results.length > 0) {
                        this.location = results[0].formatted;
                    } else {
                        this.location = '无法获取当前位置的城市信息。';
                    }
                    sessionStorage.setItem("UserLocation", this.location);
                    this.loading = false;
                })
                .catch(error => {
                    console.error('反向地理编码失败：', error);
                    this.location = '获取位置信息失败。';
                });
        }
    },
    mounted() {
        this.getCurrentLocation();
    }
};
</script>

<style scoped>
span {
    padding: 30px;
    font-size: 25px;
    color: orange;
}
</style>
