export function formatTime(date) {
    const year = date.getFullYear()
    const month = date.getMonth() + 1
    const day = date.getDate()
    const hour = date.getHours()
    const minute = date.getMinutes()
    const second = date.getSeconds()

    return [year, month, day].map(formatNumber).join('-') + ' ' + [hour, minute, second].map(formatNumber).join(':')
}

export function formatDate(date) {
    const year = date.getFullYear()
    const month = date.getMonth() + 1
    const day = date.getDate()

    return [year, month, day].map(formatNumber).join('-')
}

const formatNumber = n => {
    n = n.toString()
    return n[1] ? n : '0' + n
}

export function to(promise) {
    if (!promise || !Promise.prototype.isPrototypeOf(promise)) {
        return new Promise((resolve, reject) => {
            reject(new Error("requires promises as the param"));
        }).catch((err) => {
            return [err, null];
        });
    }
    return promise.then(function() {
        return [null, ...arguments];
    }).catch(err => {
        return [err, null];
    });
}

const toDecimal = x => {
    var f = parseFloat(x);
    if (isNaN(f)) {
        return;
    }
    f = Math.round(x * 100) / 100;
    return f;
}

export function random(min, max) {
    return toDecimal(Math.random() * (max - min) + min);
}

export function randomInt(min, max) {
    return Math.floor(toDecimal(Math.random() * (max - min) + min));
}

export function randomDate(startDate, endDate) {
    let date = new Date(+startDate + Math.random() * (endDate - startDate));
    let hour = 0 + Math.random() * (23 - 0) | 0;
    let minute = 0 + Math.random() * (59 - 0) | 0;
    let second = 0 + Math.random() * (59 - 0) | 0;
    date.setHours(hour);
    date.setMinutes(minute);
    date.setSeconds(second);
    return date;
}

export function addDay(date, days) {
    let d = new Date(date)
    d.setDate(d.getDate() + days)
    return formatDate(d)
}

export function addHours(date, hours) {
    let d = new Date(date)
    d.setHours(d.getHours() + hours)
    return formatTime(d)
}

export function getDayHour(date, hours) {
    let d = addHours(date, hours)
    let a = d.split('-')
    a.splice(0, 1)
    return a.join('-')
}

export function getWeek(weekNo) {
    return ['周日', '周一', '周二', '周三', '周四', '周五', '周六'][weekNo];
}