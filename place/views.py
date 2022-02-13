from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from .models import Place
from django.db import connection
import json
import time


def index(request):
    if request.user.is_authenticated and request.user.is_staff:
        return render(request, "place.html")
    else:
        return render(request, "login.html")


def obtainForm(request):
    '''提取表单信息
    '''
    try:
        return json.loads(request.body)
    except:
        return request.POST


@login_required
def add_place(request) -> json:
    '''创建新地点
    '''
    response = {}
    if request.method == "POST" and request.user.is_staff:
        try:
            form = obtainForm(request)
            # 查询地点
            if Place.objects.filter(name=form.get("name"), is_delete=False).exists():
                response['return_msg'] = "已存在"
                response['return_code'] = "fail"
            else:
                place = Place.objects.create(name=form.get("name"), add_by=request.user.id)
                place.save()

                # 如果不是超级管理员的话，那么添加的场地都归为自己的权限内
                if request.user.is_superuser == False:
                    place = Place.objects.get(name=form.get("name"))
                    if request.user.place_id_list == '0':
                        request.user.place_id_list = str(place.id)
                    else:
                        place_id_list = list(map(int, request.user.place_id_list.split(',')))
                        place_id_list.append(place.id)
                        request.user.place_id_list = ','.join('%s' % id for id in place_id_list)
                    request.user.save()

                response['return_msg'] = "创建成功"
                response['return_code'] = "success"
        except Exception as error:
            response['return_msg'] = "创建失败"
            response['return_code'] = "fail"
            response["error_msg"] = str(error)
    else:
        response['return_msg'] = "非法请求"
        response['return_code'] = "fail"
        response["error_msg"] = "未使用POST的错误请求"
    return JsonResponse(response)


@login_required
def delete_place(request) -> json:
    '''删除地点
    '''
    response = {}
    if request.method == "POST" and request.user.is_staff:
        try:
            form = obtainForm(request)
            place = Place.objects.get(id=form.get("id"), is_delete=False)
            place.is_delete = True
            place.delete_by = request.user.id
            place.delete_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
            place.save()

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

def fetch_dict_result(cur):
    row_headers = [x[0] for x in cur.description]
    rv = cur.fetchall()
    json_data = []
    for result in rv:
        json_data.append(dict(zip(row_headers, result)))
    data = json.dumps(json_data, default=str, ensure_ascii=False)
    return json.loads(data)

@login_required
def get_all_place(request):
    '''获取所有场地
    '''
    response = {}
    try:
        sql = 'select \
            place.id, \
            place.name, \
            user.username addBy \
        from  \
            place_place place, auth_user user \
        where \
            place.is_delete = 0 and \
            place.add_by = user.id'
        cursor = connection.cursor()
        cursor.execute(sql)
        place_list = fetch_dict_result(cursor)
        response["return_msg"] = place_list
        response["return_code"] = "success"
    except Exception as error:
        response['return_msg'] = "获取失败"
        response['return_code'] = "fail"
        response["error_msg"] = str(error)
    return JsonResponse(response)

@login_required
def get_place_list(request):
    '''获取权限内场地
    '''

    if request.user.is_superuser:
        return get_all_place(request)

    response = {}
    try:
        if request.user.place_id_list != '0':
            place_id_list = list(map(int, request.user.place_id_list.split(',')))
            # 查出所有场地，从中筛选
            places = Place.objects.filter(is_delete=False)
            place_list = [{'name': place.name, 'id': place.id} for place in places if place.id in place_id_list]
        else:
            place_list = []
        response["return_msg"] = place_list
        response["return_code"] = "success"
    except Exception as error:
        response['return_msg'] = []
        response['return_code'] = "success"
        response["error_msg"] = str(error)
    return JsonResponse(response)
