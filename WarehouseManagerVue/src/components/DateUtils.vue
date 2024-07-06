<template >
    <div style="padding: 30px;font-size: 30px;color: orange;">
        <span class="time" id="time" >
            <span class="date">{{ nowTime }}</span>
            <span class="hour" style="margin-left: 5px;">{{time.hour}}</span>
            <a class="split">:</a>
            <span class="minitus">{{time.minitus}}</span>
            <a class="split">:</a>
            <span class="seconds">{{time.seconds}}</span>
        </span>
    </div>
</template>

<script>
    export default {
        name: "DateUtils",
        props: ["s"],
        data() {
            return {
                time: {
                    hour: "",
                    minitus: "",
                    seconds: ""
                },
                nowTime: "",
                week: [
                    "周日",
                    "周一",
                    "周二",
                    "周三",
                    "周四",
                    "周五",
                    "周六"
                ]
            };
        },
        mounted() {
            this.dateTime();
        },
        methods: {
            dateTime() {
                this.timeFormate();
                setTimeout(() => {
                    this.dateTime();
                }, 1000);
            },
            timeFormate() {
                const newtime = new Date();
                this.time.hour = this.getIncrease(newtime.getHours(), 2);
                this.time.minitus = this.getIncrease(newtime.getMinutes(), 2);
                this.time.seconds = this.getIncrease(newtime.getSeconds(), 2);
                this.nowTime =
                    this.getIncrease(newtime.getFullYear(), 4) +
                    "年" +
                    this.getIncrease(newtime.getMonth() + 1, 2) +
                    "月" +
                    this.getIncrease(newtime.getDate(), 2) +
                    "日 " +
                    this.week[newtime.getDay()];
                //this.hour=
               // return `${this.time.hour}:${this.time.minitus}:${this.time.seconds}`;
            },
            getIncrease(num, digit) {
                var increase = "";
                for (var i = 0; i < digit; i++) {
                    increase += "0";
                }
                return (increase + num).slice(-digit);
            }
        }
    }
</script>

<style scoped>
    .txt-data .time {
        font-size: 1rem;
        margin-right: 0.5rem;
    }
    .split {
        animation: shark 1s step-end infinite;
        vertical-align: center;
        margin-left: 2px;
        margin-right: 2px;
    }
    @keyframes shark {
        0%,
        100% {
            opacity: 1;
        }
        50% {
            opacity: 0;
        }
    }
</style>