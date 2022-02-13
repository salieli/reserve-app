import {get, postWithJson, multipartForm } from '@/common/httpUtil'


/**
 * 带加载的请求数据
 *
 * @param {Function} func 函数
 * @param {String} msg 显示的信息
 * @param {Boolean} loading 是否显示加载
 * @return {Promise}
 */
export async function exec(func, msg = null, loading = true) {
    let res = null;
    if (loading) {
        const loading = this.$loading({
            lock: true,
            text: "处理中...",
            spinner: "el-icon-loading",
            background: "rgba(0, 0, 0, 0.7)",
        });
        res = await func();
        loading.close();
    } else {
        res = await func();
    }

    if (res) {
        if (res.data.return_code === "success") {
            if (msg) {
                this.$message.success(msg);
            }
            return res.data.return_msg;
        } else {
            this.$message.error(res.data.return_msg);
            return false;
        }
    }
}

/*==============================================================*/
// 预约界面
/*==============================================================*/

/**
 * @description 预约操作
 */
class Reserve {
    constructor() {}

    /**
     * @description 获取所预约信息
     * @param {Object} option 查询条件
     * @returns {Object} 结果信息
     */
    getReserveData(option) {
        return postWithJson('/reserve/getreservedata', option);
    }

    /**
     * @description 提交预约信息
     * @param {Object} data 预约信息
     * @returns {Object} 结果信息
     */
    submitReserveData(data) {
        return postWithJson('/reserve/submitreservedata', data);
    }

    /**
     * @description 查询预约数据
     * @param {String} type 类型
     * @param {Object} option 查询条件
     * @returns {Object} 结果信息
     */
    getReserveDataByType(type, option) {

        // 待审核，管理员查看当前所有待审核
        if (type === "auditing") {
            return this.getAllAuditing(option);
        }

        // 管理员获取所有已通过的数据
        if (type === "passed") {
            return this.getAllPassed(option);
        }

        // 管理员获取所有已拒绝的数据
        if (type === "rejected") {
            return this.getAllRejected(option);
        }

        // 用户获取当前所有预约数据
        if (type === "now") {
            return this.getNow(option);
        }

        // 用户获取历史审核通过数据
        if (type === "historicalpassed") {
            return this.getHistoryPassed(option);
        }

        // 用户获取历史审核拒绝数据
        if (type === "historicalrejected") {
            return this.getHistoryRejected(option);
        }
    }

    /**
     * @description 查询当前所有待审核的预约申请 [管理员]
     * @param {Object} option 查询条件
     * @returns {Object} 结果信息
     */
    getAllAuditing(option) {
        return postWithJson('/reserve/getallauditing', option);
    }

    /**
     * @description 查询所有已审核通过的预约申请 [管理员]
     * @param {Object} option 查询条件
     * @returns {Object} 结果信息
     */
    getAllPassed(option) {
        return postWithJson('/reserve/getallpassed', option);
    }

    /**
     * @description 查询所有已拒绝的预约申请 [管理员]
     * @param {Object} option 查询条件
     * @returns {Object} 结果信息
     */
    getAllRejected(option) {
        return postWithJson('/reserve/getallrejected', option);
    }

    /**
     * @description 查询当前提交的所有预约申请 [用户]
     * @param {Object} option 查询条件
     * @returns {Object} 结果信息
     */
    getNow(option) {
        return postWithJson('/reserve/getnow', option);
    }

    /**
     * @description 查询出今天之前提交的所有审核通过的预约申请 [用户]
     * @param {Object} option 查询条件
     * @returns {Object} 结果信息
     */
    getHistoryPassed(option) {
        return postWithJson('/reserve/gethistorypassed', option);
    }

    /**
     * @description 查询出今天之前提交的所有审核拒绝的预约申请 [用户]
     * @param {Object} option 查询条件
     * @returns {Object} 结果信息
     */
    getHistoryRejected(option) {
        return postWithJson('/reserve/gethistoryrejected', option);
    }

    /**
     * @description 修改预约数据的状态
     * @param {Number} id 数据id
     * @param {Number} status 数据要修改的状态
     * @returns {Object} 结果信息
     */
    updateReserveStatus(id, status) {
        return postWithJson('/reserve/updatereservestatus', { id: id, status: status });
    }
}


/*==============================================================*/
// 用户界面
/*==============================================================*/

/**
 * @description 用户管理
 */
class User {
    constructor() {}

    /**
     * @description 登录
     * @param {String} username 用户名
     * @param {String} password 密码
     * @returns {Object} 结果
     */
    login(username, password) {
        return postWithJson("/account/login", { username: username, password: password });
    }

    /**
     * @description 注销
     * @returns {Object} 结果
     */
    logout() {
        return get('/account/logout');
    }


    /**
     * @description 获取所有用户信息，未删除的
     * @returns {Array} 用户信息列表 
     */
    getAll() {
        return get('/account/all');
    }

    /**
     * @description 给用户授权
     * @returns {Array} 用户信息列表 
     */
    authorize(option) {
        return postWithJson('/account/authorize', option);
    }

    /**
     * @description 添加用户
     * @param {Object} user 用户对象
     * @returns {Object} 结果信息
     */
    add(name) {
        return postWithJson('/account/add', { username: name });
    }

    /**
     * @description 删除用户
     * @param {Number} id 用户id
     * @returns  {Object} 结果信息
     */
    delete(id) {
        return postWithJson('/account/delete', { id: id });
    }

    /**
     * @description 重置用户密码
     * @param {Number} id 用户id
     * @returns  {Object} 结果信息
     */
    resetUserPassword(id) {
        return postWithJson('/account/resetpassword', { id: id });
    }

    /**
     * @description 用户修改密码
     * @param {String} oldPassword 旧密码
     * @param {String} newPassword 新密码
     * @returns {Object} 结果信息
     */
    changePassword(oldPassword, newPassword) {
        return postWithJson('/account/changepassword', { oldPassword: oldPassword, newPassword: newPassword });
    }

    /**
     * @description 获取用户
     * @returns {Object} 结果信息
     */
    getUser() {
        return get('/account/user');
    }
}


/**
 * @description 场地管理
 */
class Place {
    constructor() {}

    /**
     * @description 获取所有场地信息，未删除的
     * @returns  {Object} 结果信息
     */
    getAll() {
        return get('/place/all');
    }

    /**
     * @description 获取用户权限内所有场地信息
     * @returns  {Object} 结果信息
     */
    getPlaceList() {
        return get('/place/list');
    }

    /**
     * @description 添加场地
     * @param {String} name 场地名称
     * @returns  {Object} 结果信息
     */
    add(name) {
        return postWithJson('/place/add', { name: name });
    }

    /**
     * @description 删除场地
     * @param {Number} id 场地id
     * @returns  {Object} 结果信息
     */
    delete(id) {
        return postWithJson('/place/delete', { id: id });
    }
}


/**
 * @description 首页内容管理
 */
class Content {
    constructor() {}

    /**
     * @description 获取所有内容
     * @returns  {Object} 结果信息
     */
    getAll() {
        return get('/content/all');
    }


    /**
     * @description 添加内容
     * @param {Number} dataType 内容类型
     * @param {String} dataContent 内容数据
     * @returns  {Object} 结果信息
     */
    add(dataType, dataContent) {
        return postWithJson('/content/add', { dataType: dataType, dataContent: dataContent });
    }

    /**
     * @description 更新内容
     * @param {Number} id 内容id
     * @param {String} dataContent 内容数据
     * @returns  {Object} 结果信息
     */
    update(id, dataContent) {
        return postWithJson('/content/update', { id: id, dataContent: dataContent });
    }

    /**
     * @description 上传图片
     * @param {Object} formData 图片数据
     * @returns  {Object} 结果信息
     */
    uploadImage(formData) {
        return multipartForm('/content/uploadimage', formData);
    }

    /**
     * @description 删除图片
     * @param {String} url 图片链接
     * @returns  {Object} 结果信息
     */
    deleteImage(url) {
        return postWithJson('/content/deleteimage', { url: url });
    }
}

export let ReserveStatus = {
    AUDITING: 0, // 正在审核
    PASSED: 1, // 已通过审核
    REJECTED: 2, // 已被拒绝
    CANCELLED: 3 // 已取消
}

export let ReserveManager = new Reserve();
export let UserManager = new User();
export let PlaceManager = new Place();
export let ContentManager = new Content();