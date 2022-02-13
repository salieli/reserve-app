<template>
<div style="width:100%;height:100%">
    <div class="calendar-container">
        <div class="custom-calendar-wrap custom-calendar-full">
            <div class="custom-header clearfix">
                <div class="place-select">
                    <el-select v-model="place" placeholder="请选择" size="small" @change="dataChange">
                        <el-option v-for="o in placeList" :key="o.id" :label="o.name" :value="o.id">
                        </el-option>
                    </el-select>
                    <el-button style="margin-left:10px;padding: 9px 15px;width:auto;font-size: 12px;" type="primary" size="small" @click="displayForm">进行预约</el-button>
                    <el-button style="margin-left:10px;padding: 9px 15px;width:auto;font-size: 12px;" type="danger" size="small" @click="navigateBack">返回主页</el-button>

                </div>
                <h3 class="custom-month-year">
                    <span id="custom-year" class="custom-year">{{year}}年</span>
                    <span id="custom-month" class="custom-month">{{month}}月</span>
                </h3>
            </div>
            <div id="calendar" class="fc-calendar-container">
                <div class="fc-calendar fc-three-rows">
                    <div class="fc-head">
                        <div>周日</div>
                        <div>周一</div>
                        <div>周二</div>
                        <div>周三</div>
                        <div>周四</div>
                        <div>周五</div>
                        <div>周六</div>
                    </div>
                    <div class="fc-body">
                        <div class="fc-row" v-for="(o, i) in arr" :key="i">
                            <div v-for="b in o" :key="b.day" class="scroll-y">
                                <span v-if="!b.empty" :class="`${b.current === true ? 'fc-date current':'fc-date'}`">{{b.day}}</span>
                                <span class="fc-weekday" v-if="!b.empty">{{b.week}}</span>
                                <div class="user-list" v-if="b.list.length > 0">
                                    <a class="user-info" v-for="d in b.list" :key="d.id">{{ d.usageStartTime }}~{{ d.usageEndTime }} {{ d.username }} </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</template>

<script>
import * as Util from "@/common/util.js";
import EventBus from '@/common/eventBus.js';
import {homeUrl} from '@/common/config.js';
// import * as Fake from "@/common/fakeData.js";

export default {
    name: "Calendar",
    data() {
        return {
            placeList: [],
            place: "",
            placeName: "",
            month: "",
            year: "",
            tempList: [],
            arr: []
        };
    },

    async mounted() {
        this.initData();

        this.placeList = await this.$exec(async () => await this.$PlaceManager.getPlaceList()) || [];
        if(this.placeList.length === 0){
            this.$message.warning("无权限查看")
            return;
        }
        // this.placeList = Fake.placeList();

        let place = sessionStorage.getItem("place");
        if (place) {
            sessionStorage.removeItem("place");
            place = JSON.parse(place);
            this.place = place.id;
            this.getData(place.id);
        } else {
            this.place = this.placeList[0].id;
            this.getData(this.placeList[0].id);
        }
    },
    created() {
        EventBus.$on('refresh', () => {
            this.getData(this.place);
        })
    },
    methods: {
        dataChange(newPlace) {
            this.getData(newPlace);
        },
        displayForm() {
            this.$emit("showForm");
        },
        navigateBack() {
            window.location.href = homeUrl;
        },
        initData() {
            let date = new Date();
            this.year = date.getFullYear();
            this.month = date.getMonth() + 1;
            this.today = date.getDate();
            this.weekNo = date.getDay();
            let lastDay = new Date(this.year, this.month, 0).getDate();
            let nextMonthLastDay = new Date(this.year, this.month + 1, 0).getDate();
            let day = this.today;
            let weekNo = this.weekNo;

            let arr = Array.apply(null, {
                length: this.weekNo === 0 ? 2 : 3
            }).map(() => ([]));
            arr[0] = Array.apply(null, {
                length: this.weekNo
            }).map(() => ({
                empty: true
            }));

            for (let i = 0, j = 0; i < 14; i++) {
                if (day > lastDay) {
                    day = 1;
                    lastDay = nextMonthLastDay;
                }
                let d = Util.addDay(date, i);

                arr[j].push({
                    day: day++,
                    date: d,
                    list: [],
                    week: Util.getWeek(weekNo % 7)
                })

                if (++weekNo % 7 === 0) {
                    j++;
                }

            }

            arr[0][this.weekNo].current = true;
            arr[arr.length - 1] = arr[arr.length - 1].concat(Array.apply(null, {
                length: 7 - weekNo % 7
            }).map(() => ({
                empty: true
            })));

            this.tempList = arr;
        },

        async getData(id) {
            let arr = this.tempList;
            let a = await this.$exec(async () => await this.$ReserveManager.getReserveData({
                startDate: arr[0][this.weekNo].date,
                placeId: id
            }));

            // let a = Fake.reserveData();

            for (let i = 0; i < arr.length; i++) {
                for (let j = 0; j < arr[i].length; j++) {
                    arr[i][j].list = a.filter(v => {
                        return v.usageDate === arr[i][j].date
                    })
                }
            }

            this.arr = arr;
        }

    },
};
</script>

<style scoped>
@media (max-width: 380px) {
    .place-select .el-select {
        width: 120px !important;
    }
}

.el-select-dropdown__item {
    padding: 0 20px !important;
}

.calendar-title {
    text-align: center;
    font-size: 2rem;
}

.current {
    font-size: 2rem !important;
    font-weight: bolder !important;
    color: #409EFF !important;
    text-shadow: 2px 2px 12px #409EFF !important;
}

.place-select {
    float: left;
    width: 60%;
}

.custom-month-year {
    color: #409EFF;
    font-weight: bolder;
}

.scroll-y {
    overflow-y: auto !important;
}

.user-info {
    font-size: 1rem !important;
}

.scroll-y::-webkit-scrollbar {
    width: 10px;
    height: 1px;
}

.scroll-y::-webkit-scrollbar-thumb {
    border-radius: 10px;
    background-color: rgb(206, 215, 219);
    background-image: -webkit-linear-gradient(45deg,
            rgba(255, 255, 255, 0.2) 25%,
            transparent 25%,
            transparent 50%,
            rgba(255, 255, 255, 0.2) 50%,
            rgba(255, 255, 255, 0.2) 75%,
            transparent 75%,
            transparent);
}

.scroll-y::-webkit-scrollbar-track {
    border-radius: 10px;
}

*,
*:after,
*:before {
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
    margin: 0;
}

.clearfix:before,
.clearfix:after {
    content: " ";
    display: table;
}

.clearfix:after {
    clear: both;
}

.clearfix {
    *zoom: 1;
}

a {
    color: #555;
    text-decoration: none;
}

.calendar-container {
    width: 100%;
    height: 100%;
    position: relative;
}

/* fc-calendar-container */

.fc-calendar-container {
    position: relative;
    height: 400px;
    width: 400px;
}

.fc-calendar {
    width: 100%;
    height: 100%;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, .1);
}

.fc-calendar .fc-head {
    height: 30px;
    line-height: 30px;
    background: #ccc;
    color: #333;
}

.fc-calendar .fc-body {
    position: relative;
    width: 100%;
    height: 100%;
    height: -moz-calc(100% - 30px);
    height: -webkit-calc(100% - 30px);
    height: calc(100% - 30px);
    border: 1px solid #ddd;
}

.fc-calendar .fc-row {
    width: 100%;
    border-bottom: 1px solid #ddd;
}

.fc-three-rows .fc-row {
    height: 33.3%;
}

.fc-four-rows .fc-row {
    height: 25%;
}

.fc-five-rows .fc-row {
    height: 20%;
}

.fc-six-rows .fc-row {
    height: 16.66%;
    height: -moz-calc(100%/6);
    height: -webkit-calc(100%/6);
    height: calc(100%/6);
}

.fc-calendar .fc-row>div,
.fc-calendar .fc-head>div {
    float: left;
    height: 100%;
    width: 14.28%;
    /* 100% / 7 */
    width: -moz-calc(100%/7);
    width: -webkit-calc(100%/7);
    width: calc(100%/7);
    position: relative;
}

/* IE 9 is rounding up the calc it seems */

.ie9 .fc-calendar .fc-row>div,
.ie9 .fc-calendar .fc-head>div {
    width: 14.2%;
}

.fc-calendar .fc-row>div {
    border-right: 1px solid #333;
    padding: 4px;
    overflow: hidden;
    position: relative;
}

.fc-calendar .fc-head>div {
    text-align: center;
}

.fc-calendar .fc-row>div>span.fc-date {
    position: absolute;
    width: 30px;
    height: 20px;
    font-size: 20px;
    line-height: 20px;
    font-weight: 700;
    color: #333;
    text-shadow: 0 -1px 0 rgba(255, 255, 255, 0.8);
    bottom: 5px;
    right: 5px;
    text-align: right;
}

.fc-calendar .fc-row>div>span.fc-weekday {
    padding-left: 5px;
    display: none;
}

.fc-calendar .fc-row>div.fc-today {
    background: #fff4c3;
}

.fc-calendar .fc-row>div.fc-out {
    opacity: 0.6;
}

.fc-calendar .fc-row>div:last-child,
.fc-calendar .fc-head>div:last-child {
    border-right: none;
}

.fc-calendar .fc-row:last-child {
    border-bottom: none;
}

.custom-calendar-full {
    position: absolute;
    top: 24px;
    bottom: 0px;
    left: 0px;
    width: 100%;
    height: auto;
}

.fc-calendar-container {
    height: auto;
    bottom: 0px;
    width: 100%;
    top: 50px;
    position: absolute;
}

.custom-header {
    padding: 20px 20px 10px 30px;
    height: 50px;
    position: relative;
}

.custom-header h2,
.custom-header h3 {
    float: left;
    font-weight: bolder;
    text-transform: uppercase;
    letter-spacing: 4px;
    text-shadow: 1px 1px 0 rgba(0, 0, 0, 0.1);
}

.custom-header h2 {
    color: #fff;
    width: 60%;
}

.custom-header h2 a,
.custom-header h2 span {
    color: rgba(255, 255, 255, 0.3);
    font-size: 18px;
    letter-spacing: 3px;
    white-space: nowrap;
}

.custom-header h2 a {
    color: rgba(255, 255, 255, 0.5);
}

.no-touch .custom-header h2 a:hover {
    color: rgba(255, 255, 255, 0.9);
}

.custom-header h3 {
    width: 40%;
    color: #000;
    font-size: 1.5rem;
    /* color: rgba(255, 255, 255, 0.6); */
    font-weight: bolder;
    line-height: 30px;
    text-align: right;
    /* padding-right: 125px; */
}

.custom-header nav {
    position: absolute;
    right: 20px;
    top: 20px;
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
}

.custom-header nav span {
    float: left;
    width: 30px;
    height: 30px;
    position: relative;
    color: transparent;
    cursor: pointer;
    background: rgba(255, 255, 255, 0.3);
    margin: 0 1px;
    font-size: 20px;
    border-radius: 0 3px 3px 0;
    box-shadow: inset 0 1px rgba(255, 255, 255, 0.2);
}

.custom-header nav span:first-child {
    border-radius: 3px 0 0 3px;
}

.custom-header nav span:hover {
    background: rgba(255, 255, 255, 0.5);
}

.custom-header span:before {
    font-family: 'fontawesome-selected';
    color: #fff;
    display: inline-block;
    text-align: center;
    width: 100%;
    text-indent: 4px;
}

.custom-header nav span.custom-prev:before {
    content: '\25c2';
}

.custom-header nav span.custom-next:before {
    content: '\25b8';
}

.custom-header nav span:last-child {
    margin-left: 20px;
    border-radius: 3px;
}

.custom-header nav span.custom-current:before {
    content: '\27a6';
}

.fc-calendar {
    background: rgba(255, 255, 255, 0.1);
    width: auto;
    top: 10px;
    bottom: 20px;
    left: 20px;
    right: 20px;
    height: auto;
    border-radius: 20px;
    position: absolute;
}

.fc-calendar .fc-head {
    background: rgba(255, 255, 255, 0.2);
    color: #333;
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2);
    border-radius: 20px 20px 0 0;
    height: 40px;
    line-height: 40px;
    padding: 0 20px;
}

.fc-calendar .fc-head>div {
    font-weight: 300;
    text-transform: uppercase;
    font-size: 14px;
    letter-spacing: 3px;
    text-shadow: 0 1px 1px rgba(0, 0, 0, 0.4);
}

.fc-calendar .fc-row>div>span.fc-date {
    color: #333;
    text-shadow: none;
    font-size: 26px;
    font-weight: 300;
    bottom: auto;
    right: auto;
    top: 10px;
    left: 10px;
    text-align: left;
    text-shadow: 0 1px 1px #ddd;
}

.fc-calendar .fc-body {
    border: none;
    padding: 20px;
}

.fc-calendar .fc-row {
    box-shadow: inset 0 -1px 0 #ddd;
    border: none;
}

.fc-calendar .fc-row:last-child {
    box-shadow: none;
}

.fc-calendar .fc-row:first-child>div:first-child {
    border-radius: 10px 0 0 0;
}

.fc-calendar .fc-row:first-child>div:last-child {
    border-radius: 0 10px 0 0;
}

.fc-calendar .fc-row:last-child>div:first-child {
    border-radius: 0 0 0 10px;
}

.fc-calendar .fc-row:last-child>div:last-child {
    border-radius: 0 0 10px 0;
}

.fc-calendar .fc-row>div {
    box-shadow: -1px 0 0 #ddd;
    border: none;
    padding: 10px;
    cursor: pointer;
}

.fc-calendar .fc-row>div:first-child {
    box-shadow: none;
}

.fc-calendar .fc-row>div.fc-today {
    background: transparent;
    box-shadow: inset 0 0 100px rgba(255, 255, 255, 0.1);
}

.fc-calendar .fc-row>div.fc-today:after {
    content: '';
    display: block;
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    opacity: 0.2;
    background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(rgba(255, 255, 255, 0.15)), to(rgba(0, 0, 0, 0.25))), -webkit-gradient(linear, left top, right bottom, color-stop(0, rgba(255, 255, 255, 0)), color-stop(0.5, rgba(255, 255, 255, .15)), color-stop(0.501, rgba(255, 255, 255, 0)), color-stop(1, rgba(255, 255, 255, 0)));
    background: -moz-linear-gradient(top, rgba(255, 255, 255, 0.15), rgba(0, 0, 0, 0.25)), -moz-linear-gradient(left top, rgba(255, 255, 255, 0), rgba(255, 255, 255, 0.15) 50%, rgba(255, 255, 255, 0) 50%, rgba(255, 255, 255, 0));
    background: -o-linear-gradient(top, rgba(255, 255, 255, 0.15), rgba(0, 0, 0, 0.25)), -o-llinear-gradient(left top, rgba(255, 255, 255, 0), rgba(255, 255, 255, 0.15) 50%, rgba(255, 255, 255, 0) 50%, rgba(255, 255, 255, 0));
    background: -ms-linear-gradient(top, rgba(255, 255, 255, 0.15), rgba(0, 0, 0, 0.25)), -ms-linear-gradient(left top, rgba(255, 255, 255, 0), rgba(255, 255, 255, 0.15) 50%, rgba(255, 255, 255, 0) 50%, rgba(255, 255, 255, 0));
    background: linear-gradient(top, rgba(255, 255, 255, 0.15), rgba(0, 0, 0, 0.25)), linear-gradient(left top, rgba(255, 255, 255, 0), rgba(255, 255, 255, 0.15) 50%, rgba(255, 255, 255, 0) 50%, rgba(255, 255, 255, 0));
}

.fc-calendar .fc-row>div>div {
    margin-top: 35px;
}

.fc-calendar .fc-row>div>div a,
.fc-calendar .fc-row>div>div span {
    color: #444;
    font-size: 12px;
    text-transform: uppercase;
    display: inline-block;
    padding: 3px 5px;
    border-radius: 3px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 100%;
    margin-bottom: 1px;
    background: #f2f6fc;
}

.no-touch .fc-calendar .fc-row>div>div a:hover {
    background: rgba(255, 255, 255, 0.3);
}

@media screen and (max-width: 880px),
screen and (max-height: 450px) {
    .place-select {
        width: 100%;
    }

    html,
    body,
    .container {
        height: auto;
    }

    .custom-header,
    .custom-header nav,
    .custom-calendar-full,
    .fc-calendar-container,
    .fc-calendar,
    .fc-calendar .fc-head,
    .fc-calendar .fc-row>div>span.fc-date {
        position: relative;
        top: auto;
        left: auto;
        bottom: auto;
        right: auto;
        height: auto;
        width: auto;
    }

    .fc-calendar {
        margin: 0;
    }

    .custom-header {
        padding: 20px 0 10px 0;
    }

    .custom-header h2,
    .custom-header h3 {
        float: none;
        width: auto;
        text-align: left;
        padding-right: 100px;
    }

    .user-info {
        font-size: .2rem !important;
    }

    .fc-calendar .fc-row,
    .ie9 .fc-calendar .fc-row>div,
    .fc-calendar .fc-row>div {
        height: auto;
        width: 100%;
        border: none;
    }

    .fc-calendar .fc-row>div {
        float: none;
        min-height: 50px;
        box-shadow: inset 0 -1px #ddd !important;
        border-radius: 0px !important;
    }

    .fc-calendar .fc-row>div:empty {
        min-height: 0;
        height: 0;
        box-shadow: none !important;
        padding: 0;
    }

    .fc-calendar .fc-row {
        box-shadow: none;
    }

    .fc-calendar .fc-head {
        display: none;
    }

    .fc-calendar .fc-row>div>div {
        margin-top: 0px;
        padding-left: 10px;
        max-width: 70%;
        display: inline-block;
    }

    .fc-calendar .fc-row>div.fc-today {
        background: rgba(255, 255, 255, 0.2);
    }

    .fc-calendar .fc-row>div.fc-today:after {
        display: none;
    }

    .fc-calendar .fc-row>div>span.fc-date {
        width: 30px;
        display: inline-block;
        text-align: right;
    }

    .fc-calendar .fc-row>div>span.fc-weekday {
        display: inline-block;
        width: 40px;
        color: rgb(216, 55, 55);
        font-size: 10px;
        text-transform: uppercase;
    }
}
</style>
