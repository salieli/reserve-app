import * as Util from './util.js'
import moment from 'moment'

export function userList(num) {
    let nameList = ["信息院", "生科院", "人工智能学院", "校团委", "食品科技学院", "资源与环境管理学院", "公共卫生学院"];
    let list = [];
    for (let i = 0; i < num; i++) {
        list.push({
            id: i,
            name: nameList[Util.randomInt(0, 7)],
            isStaff: Util.random(0, 10) > 5 ? true : false,
            isSuperuser: Util.random(0, 10) > 5 ? true : false,
        })
    }
    return list;
}
export function placeList() {
    let nameList = ["大学生活动中心", "教七楼", "教四楼", "三食堂", "教学楼202", "教学楼2302", "教学楼2202", "教四楼", "三食堂", "教学楼202"];
    let list = [];
    for (let i = 0; i < nameList.length; i++) {
        list.push({
            id: i,
            name: nameList[i]
        })
    }
    return list;
}

export function user() {
    return {
        id: 1,
        name: "信息院",
        isStaff: Util.random(0, 10) > 5 ? true : false,
        isSuperuser: Util.random(0, 10) > 5 ? true : false,
        isVip: Util.random(0, 10) > 5 ? true : false,
    };
}

export function reserveData() {
    let a = [];
    for (let i = 0; i < 30; i++) {
        a.push({
            id: i,
            status: 1,
            usageStartTime: moment(Util.randomDate(new Date(), new Date("2021-1-16"))).format('HH:mm'),
            usageEndTime: moment(Util.randomDate(new Date(), new Date("2021-1-16"))).format('HH:mm'),
            usageDate: moment(Util.randomDate(new Date(), new Date("2021-1-16"))).format('YYYY-MM-DD'),
            username: "信息院",
            contactManTelephone: "18051990381",
            contactManName: "信息院的人",
            usageReason: "信息院".repeat(Util.random(0, 10))
        })
    }
    return a;
}

export function notice() {
    let noticeData = '<h1 class="ql-align-center"><strong>场地使用须知</strong></h1><p><span class="ql-size-large">1、啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊</span></p><p><span class="ql-size-large">2、第三方发的发的方式打</span><span class="ql-size-large" style="color: rgb(230, 0, 0);">发斯蒂芬</span></p><p><span class="ql-size-large">3、发送到发士大夫士大夫士大夫十点多哈哈哈</span></p>';
    return noticeData;
}

export function imageList() {
    return "https://blog-10039692.file.myqcloud.com/1501640468638_541_1501640469080.png|https://blog-10039692.file.myqcloud.com/1501640663134_2410_1501640663593.png";
}