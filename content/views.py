from django.contrib.auth.decorators import login_required
from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from content.models import Content
import json
import uuid
import os

def homeedit(request):
    if request.user.is_authenticated and request.user.is_staff:
        return render(request, "homeedit.html")
    else:
        return render(request, "login.html")

@login_required
def add(request):
    '''添加内容
    '''

    response = {}
    if request.method == "POST":
        try:
            data = json.loads(request.body)
            content = Content.objects.create(data_type=data.get("dataType"), data_content=data.get("dataContent"))
            content.save()
            response['return_msg'] = "添加内容成功"
            response['return_code'] = "success"

        except Exception as error:
            response['return_msg'] = "添加内容失败"
            response['return_code'] = "fail"
            response["error_msg"] = str(error)
    else:
        response['return_msg'] = "非法请求"
        response['return_code'] = "fail"
        response["error_msg"] = "未使用POST的错误请求"
    return JsonResponse(response)

@login_required
def update(request):
    '''更新首页内容
    '''
    response = {}
    if request.method == "POST":
        try:
            data = json.loads(request.body)
            content = Content.objects.get(id=data.get("id"))
            content.data_content = data.get("dataContent")
            content.save()
            response['return_msg'] = "更新内容成功"
            response['return_code'] = "success"

        except Exception as error:
            response['return_msg'] = "更新内容失败"
            response['return_code'] = "fail"
            response["error_msg"] = str(error)
    else:
        response['return_msg'] = "非法请求"
        response['return_code'] = "fail"
        response["error_msg"] = "未使用POST的错误请求"
    return JsonResponse(response)

@login_required
def all(request):
    '''获取所有内容
    '''
    response = {}
    try:
        content_list = Content.objects.filter(is_used=True)
        content_list = [{'content': content.data_content, 'id': content.id} for content in content_list]
        response['return_msg'] = content_list
        response['return_code'] = "success"
    except Exception as error:
        response['return_msg'] = "获取内容失败"
        response['return_code'] = "fail"
        response["error_msg"] = str(error)

    return JsonResponse(response)

@login_required
def upload_image(request):
    '''上传图片
    '''
    response = {}
    try:
        file_list = request.FILES.getlist("file", None)
        file_url_list = []
        if len(file_list) == 0:
            return HttpResponse("没有需要上传的文件")
        else:
            for p_file in file_list:
                file_name = str(uuid.uuid1())+os.path.splitext(p_file.name)[1] 
                with open("./uploadFile/%s" % file_name, 'wb+') as f:
                        f.write(p_file.read())
                file_url_list.append("http://127.0.0.1/uploadFile/%s" % file_name)
        content = Content.objects.get(id=2)
        if content.data_content != '':
            image_list = content.data_content.split('|')
            file_url_list = image_list + file_url_list

        content.data_content = '|'.join(file_url_list)
        content.save()
        response['return_msg'] = "上传成功"
        response['return_code'] = "success"
    except Exception as error:
        response['return_msg'] = "上传失败"
        response['return_code'] = "fail"
        response["error_msg"] = str(error)

    return JsonResponse(response)

@login_required
def delete_image(request):
    '''删除图片
    '''
    response = {}
    try:
        data = json.loads(request.body)
        content = Content.objects.get(id=2)
        image_list = content.data_content.split('|')
        image_list.remove(data.get("url"))
        image_list = '|'.join(image_list)
        content.data_content = image_list
        content.save()
        response['return_msg'] = "删除成功"
        response['return_code'] = "success"
    except Exception as error:
        response['return_msg'] = "删除失败"
        response['return_code'] = "fail"
        response["error_msg"] = str(error)

    return JsonResponse(response)