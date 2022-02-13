from django.shortcuts import render
from account.models import User, Login_Log
from django.contrib.auth import login, logout
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.contrib.auth.hashers import check_password
from place.models import Place
from django.db import connection
import json
import time


def hello(request):
    if request.user.is_authenticated:
        return render(request, "index.html")
    else:
        return render(request, "login.html")


def user(request):
    if request.user.is_authenticated and request.user.is_staff:
        return render(request, "user.html")
    else:
        return render(request, "login.html")


def obtainForm(request):
    '''提取表单信息
    '''
    try:
        return json.loads(request.body)
    except:
        return request.POST


def authorize(request):
    '''给用户授权 [普通管理员][高级管理员]

    [超级管理员]权限：授权用户为[普通管理员][高级管理员]

    [普通管理员]权限：只可审核预约信息

    [高级管理员]权限：可审核预约信息、可添加用户、授权[普通管理员]、管理权限内场地

    Args:
        request:
        {
            userId:被授权者id,
            isStaff:是否设置为管理员,
            placeIdList:[场地id列表]
        }

    '''

    response = {}
    response['return_msg'] = '授权成功'
    response['return_code'] = 'success'

    # 检查授权者权限
    if request.user.is_staff == False:
        response['return_msg'] = "权限不足"
        response['return_code'] = "fail"
        return JsonResponse(response)

    form = obtainForm(request)
    try:
        # 检查被授权者是否需要更新身份，不同则更新
        user = User.objects.get(id=form.get("userId"), is_active=True)
        user.is_staff = form.get("isStaff")
        user.place_id_list = form.get("placeIdList")
        user.save()

    except Exception as error:
        response['return_msg'] = "权限修改失败"
        response['return_code'] = "fail"
        response["error_msg"] = str(error)

    return JsonResponse(response)


def user_login(request) -> json:
    '''用户登录
    '''
    response = {}
    ip = request.META['REMOTE_ADDR']
    form = obtainForm(request)
    username=form.get("username")
    if request.method == "POST":
        try:
            users = User.objects.filter(username=username, is_active=True)
            if users.exists():
                user = users[0]
                if check_password(form.get("password"), user.password):
                    is_session_key = user.session_key  # 获取登录对象的session_key
                    if is_session_key:  # 用户已登录
                        request.session.delete(is_session_key)  # 删除登录前面登录用户的session_key
                    login(request, user) # 用户信息存入session
                    users.update(session_key=request.session.session_key)  # 更新新登录user的session_key
                    response["return_msg"] = {
                        "name": user.username, "isStaff": user.is_staff, "isSuperuser": user.is_superuser}
                    response['return_code'] = "success"
                    Login_Log.objects.create(name=username, ip=ip, status="登录成功")
                else:
                    response['return_msg'] = "密码错误"
                    response['return_code'] = "fail"
                    Login_Log.objects.create(name=username, ip=ip, status="密码错误")
            else:
                response['return_msg'] = "账号不存在"
                response['return_code'] = "fail"
                Login_Log.objects.create(name=username, ip=ip, status="账号不存在")
        except Exception as error:
            response['return_msg'] = "登录失败"
            response['return_code'] = "fail"
            response["error_msg"] = str(error)
            Login_Log.objects.create(name=username, ip=ip, status=str(error))
    else:
        response['return_msg'] = "非法请求"
        response['return_code'] = "fail"
        response["error_msg"] = "未使用POST的错误请求"
        Login_Log.objects.create(name=username, ip=ip, status="非法请求")
    return JsonResponse(response)

# 用户注销


@login_required
def user_logout(request) -> json:
    response = {}
    username = request.user.username
    ip = request.META['REMOTE_ADDR']
    try:
        logout(request)
        response["return_msg"] = "注销成功"
        response['return_code'] = "success"
        Login_Log.objects.create(name=username, ip=ip, status="注销成功")
    except Exception as error:
        response['return_msg'] = "注销失败"
        response['return_code'] = "fail"
        response["error_msg"] = str(error)
        Login_Log.objects.create(name=username, ip=ip, status=str(error))
    return JsonResponse(response)


# 添加用户
@login_required
def add_user(request) -> json:
    response = {}
    if request.method == "POST" and request.user.is_staff:
        try:
            form = obtainForm(request)
            # 用户名是否存在
            if User.objects.filter(username=form.get("username"), is_active=True).exists():
                response["return_msg"] = "用户已存在"
                response["return_code"] = "fail"
            else:
                # 密码默认为123456
                user = User.objects.create_user(
                    username=form.get("username"), password="123456", add_by=request.user.id)
                user.save()
                response["return_msg"] = "注册成功"
                response['return_code'] = "success"
        except Exception as error:
            response['return_msg'] = "注册失败"
            response['return_code'] = "fail"
            response["error_msg"] = str(error)
    else:
        response['return_msg'] = "非法请求"
        response['return_code'] = "fail"
        response["error_msg"] = "未使用POST的错误请求"
    return JsonResponse(response)


def fetch_dict_result(cur):
    row_headers = [x[0] for x in cur.description]
    rv = cur.fetchall()
    json_data = []
    for result in rv:
        json_data.append(dict(zip(row_headers, result)))
    data = json.dumps(json_data, default=str, ensure_ascii=False)
    return json.loads(data)


@login_required
def get_all_user(request) -> json:
    response = {}

    try:
        sql = 'select \
                user.id, \
                user.username name, \
                user.is_staff isStaff, \
                user.place_id_list placeIdList \
            from  \
                auth_user user \
            where \
                user.is_active = 1 and \
                user.is_superuser = 0'

        cursor = connection.cursor()
        cursor.execute(sql)
        users = fetch_dict_result(cursor)
        places = Place.objects.filter(is_delete=False)
        for user in users:
            if user['placeIdList'] != '0':
                place_id_list = list(map(int, user['placeIdList'].split(',')))
                user['placeIdList'] = [place.id for place in places if place.id in place_id_list]
                user['placeNameList'] = [place.name for place in places if place.id in place_id_list]
            else:
                user['placeIdList'] = []
                user['placeNameList'] = []
            user['isStaff'] = True if user['isStaff'] == 1 else False

        response["return_msg"] = users
        response['return_code'] = "success"
    except Exception as error:
        response['return_msg'] = "获取失败"
        response['return_code'] = "fail"
        response["error_msg"] = str(error)
    return JsonResponse(response)


# 修改个人密码
@login_required
def change_password(request) -> json:
    response = {}
    if request.method == "POST":
        try:
            form = obtainForm(request)
            user = User.objects.get(
                id=request.user.id, is_active=True)
            # 校对原密码
            if check_password(form.get("oldPassword"), user.password):
                user.set_password(form.get("newPassword"))
                user.save()
                response['return_msg'] = "修改成功"
                response['return_code'] = "success"
            else:
                response['return_msg'] = "密码错误"
                response['return_code'] = "fail"
        except Exception as error:
            response['return_msg'] = "修改失败"
            response['return_code'] = "fail"
            response["error_msg"] = str(error)
    else:
        response['return_msg'] = "非法请求"
        response['return_code'] = "fail"
        response["error_msg"] = "未使用POST的错误请求"
    return JsonResponse(response)

# 重置用户密码


@login_required
def reset_password(request):
    response = {}
    if request.method == "POST" and request.user.is_staff:
        try:
            form = obtainForm(request)
            user = User.objects.filter(id=form.get("id"), is_active=True)
            if user.exists():
                user = user[0]
                user.set_password("123456")
                user.save()
                response['return_msg'] = "重置成功"
                response['return_code'] = "success"
            else:
                response['return_msg'] = "未查找到该用户"
                response['return_code'] = "fail"
        except Exception as error:
            response['return_msg'] = "重置失败"
            response['return_code'] = "fail"
            response["error_msg"] = str(error)
    else:
        response['return_msg'] = "非法请求"
        response['return_code'] = "fail"
        response["error_msg"] = "未使用POST的错误请求"
    return JsonResponse(response)

# 删除用户


@login_required
def delete_user(request):
    response = {}
    if request.method == "POST" and request.user.is_staff:
        try:
            form = obtainForm(request)
            user = User.objects.get(id=form.get("id"), is_active=True)
            user.is_active = False
            user.is_staff = False
            user.is_superuser = False
            user.delete_by = request.user.id
            user.delete_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
            user.save()
            response['return_msg'] = "删除成功"
            response['return_code'] = "success"
        except Exception as error:
            response['return_msg'] = "删除失败"
            response['return_code'] = "fail"
            response["error_msg"] = str(error)
    else:
        response['return_msg'] = "非法请求"
        response['return_code'] = "fail"
        response["error_msg"] = "未使用POST的错误请求"
    return JsonResponse(response)


@login_required
def get_user(request):
    response = {}
    response["return_msg"] = {
        "name": request.user.username,
        "isStaff": request.user.is_staff,
        "isSuperuser": request.user.is_superuser,
        "placeIdList": request.user.place_id_list
    }
    response['return_code'] = "success"
    return JsonResponse(response)


def page_not_found(request, exception):
    return render(request, '404.html', context={'error': '访问有误:页面不存在'}, status=404)


def page_error(request):
    return render(request, '404.html', context={'error': '访问有误:服务器错误'}, status=500)
