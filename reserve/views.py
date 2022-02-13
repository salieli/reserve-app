import time
from django.db.models import Q
from django.db import connection
from django.shortcuts import render
from django.http import JsonResponse
from django.contrib.auth.decorators import login_required
from .models import Reserve
import json
from .common.status import Reserve_Status, Data_Status


def index(request):
    if request.user.is_authenticated:
        return render(request, "index.html")
    else:
        return render(request, "login.html")


def submitreserve(request):
    if request.user.is_authenticated:
        return render(request, "submitreserve.html")
    else:
        return render(request, "login.html")


def viewreserve(request):
    if request.user.is_authenticated:
        return render(request, "viewreserve.html")
    else:
        return render(request, "login.html")

def checkreserve(request):
    if request.user.is_authenticated:
        return render(request, "reserve.html")
    else:
        return render(request, "login.html")

def fetch_dict_result(cur):
    row_headers = [x[0] for x in cur.description]
    rv = cur.fetchall()
    json_data = []
    for result in rv:
        json_data.append(dict(zip(row_headers, result)))
    data = json.dumps(json_data, default=str, ensure_ascii=False)
    return json.loads(data)


@login_required
def get_reserve_data(request):
    response = {}

    '''获取一条预约信息

    根据日期(date=?)和场地id(placeId=?)获取该场地指定日期的预约信息，结果为一个json数组，每项主要包括用户名和起始时间。
    管理员查看的话还多返回申请理由和提交预约的时间。
    ！！！注意：需要通过起始时间从早到晚排序再返回结果，根据用户的不同返回不同的数据。

    Args:
        request: 前端的请求，获取里面的json参数
            {
                "date":"某日日期，例如2020-12-05",
                "placeId":"场地id，例如1",
                "areYouAdmin":"yes sir（管理员权限）" 管理员的时候才加这个字段，普通用户就不要，免得被抓包了，所以需要先判断它有没有
            }

    Returns:
        {
            "return_msg":[
                {
                    "username":"生科院",
                    "usage_start_time":"开始时间",
                    "usage_end_time":"结束时间",
                    "usage_reason":"理由（管理员权限）",
                    "reserve_time":"提交预约的时间（管理员权限）",
                },
                {
                    "username":"信息院",
                    "usage_start_time":"开始时间",
                    "usage_end_time":"结束时间",
                    "usage_reason":"理由（管理员权限）",
                    "reserve_time":"提交预约的时间（管理员权yes sir限）",
                }
            ],
            "return_code":"失败或成功",
            "error_msg":"错误信息（出错时）"
        }
    '''
    try:
        data = json.loads(request.body)
        startDate = data.get('startDate')
        placeId = data.get('placeId')
        sql = 'select \
            auth_user.username username, \
            place_place.name placeName, \
            date_format(usage_start_time, "%H:%i") usageStartTime, \
            date_format(usage_end_time, "%H:%i") usageEndTime, \
            usage_date usageDate, \
            usage_reason usageReason, \
            contact_man_name contactManName, \
            contact_man_telephone contactManTelephone, \
            date_format(reserve_time, "%Y-%c-%d %H:%i:%s") reserveTime \
                from reserve_reserve, auth_user, place_place \
            where reserve_reserve.status = 1 \
                and reserve_reserve.usage_date >= "{}"  \
                and reserve_reserve.user_id = auth_user.id \
                and reserve_reserve.place_id = place_place.id \
                and place_place.id = {} \
                order by date_format(usage_start_time, "%H:%i:%s")'.format(startDate, placeId)
        cursor = connection.cursor()
        cursor.execute(sql)
        ret = fetch_dict_result(cursor)
        response['return_msg'] = ret
        response['return_code'] = 'success'

    except Exception as e:
        response['return_msg'] = '获取预约信息失败'
        response['return_code'] = 'fail'
        response['error_msg'] = str(e)
    return JsonResponse(response)


@login_required
def submit_reserve_data(request):
    '''提交一条预约信息

    用户提交的预约信息，status=0，表示未审核。管理员提交的如果没人预约则status=1，表示直接通过申请。
    ！！！注意：需要检测是否已经有人预约过了，正在预约(status=0)和已通过(status=1)都不可再预约。

    Args:
        request: 前端的请求，获取里面的json参数
            {
                "userId":"用户id",
                "placeId":"场地id",
                "usageDate":"某日日期，例如2020-12-05",
                "usageStartTime":"开始时间",
                "usageEndTime":"结束时间",
                "usageReason":"理由",
                "reserveTime":"（这个是数据库自动生成的，不用加）"
            }

    Returns:
            {
                "return_msg":"预约信息提交情况",
                "return_code":"失败或成功",
                "error_msg":"错误信息（出错时）",
            }
    '''
    response = {}
    try:
        data = json.loads(request.body)
        place_id = data.get("placeId")
        if request.user.is_superuser == False:
            place_id_list = list(map(int, request.user.place_id_list.split(',')))
            if place_id not in place_id_list:
                response['return_msg'] = '没有此场地预约权限'
                response['return_code'] = 'fail'
                return JsonResponse(response)

        usage_start_time = data.get("usageStartTime")
        usage_end_time = data.get("usageEndTime")
        usage_date = data.get("usageDate")
        usage_reason = data.get("usageReason")
        contact_man_name = data.get("contactManName")
        contact_man_telephone = data.get("contactManTelephone")
        reserve_info = Reserve.objects.filter(
            Q((Q(usage_start_time__lt=usage_end_time) & Q(usage_end_time__gte=usage_end_time)) |
              ((Q(usage_start_time__lte=usage_start_time) & Q(usage_end_time__gt=usage_start_time)))|
              ((Q(usage_start_time__gte=usage_start_time) & Q(usage_end_time__lte=usage_end_time)))
              ),
            place_id=place_id,
            status__lt=2,
            usage_date=usage_date)

        if len(reserve_info) == 0:
            if request.user.is_staff:
                reserve = Reserve(
                    user_id=request.user.id,
                    place_id=place_id,
                    usage_start_time=usage_start_time,
                    usage_end_time=usage_end_time,
                    usage_date=usage_date,
                    usage_reason=usage_reason,
                    contact_man_name=contact_man_name,
                    contact_man_telephone=contact_man_telephone,
                    status=1)
                reserve.save()
            else:
                reserve = Reserve(
                    user_id=request.user.id,
                    place_id=place_id,
                    usage_start_time=usage_start_time,
                    usage_end_time=usage_end_time,
                    usage_date=usage_date,
                    usage_reason=usage_reason,
                    contact_man_name=contact_man_name,
                    contact_man_telephone=contact_man_telephone)
                reserve.save()
            response['return_msg'] = '预约信息提交成功'
            response['return_code'] = 'success'
        else:
            response['return_msg'] = '此时间段已有预约或正在审核，预约失败'
            response['return_code'] = 'fail'
    except Exception as e:
        response['return_msg'] = '预约失败'
        response['return_code'] = 'fail'
        response['error_msg'] = str(e)
    return JsonResponse(response)


@login_required
def get_all_auditing(request):
    '''查询当前所有待审核的预约数据 [管理员]
    usage_date > now && status = 0
    '''

    return get_reserve_data_by_option(request, Data_Status.AFTER, Reserve_Status.AUDITING, True)


@login_required
def get_all_passed(request):
    '''查询所有已审核通过的预约数据 [管理员]
    status = 1
    '''

    return get_reserve_data_by_option(request, Data_Status.ALL, Reserve_Status.PASSED, True)


@login_required
def get_all_rejected(request):
    '''查询所有已拒绝的预约数据 [管理员]
    status = 2
    '''
    return get_reserve_data_by_option(request, Data_Status.ALL, Reserve_Status.REJECTED, True)


@login_required
def get_now(request):
    '''查询当前提交的所有预约申请 [普通用户][管理员]
    userId = ? && status != 3 && usage_date > now
    '''
    return get_reserve_data_by_option(request, Data_Status.AFTER, Reserve_Status.CANCELLED, False)


@login_required
def get_history_passed(request):
    '''查询历史的已审核通过的预约数据 [普通用户][管理员]
    userId = ? && usage_date < now && status=1
    '''
    return get_reserve_data_by_option(request, Data_Status.BEFORE, Reserve_Status.PASSED, False)


@login_required
def get_history_rejected(request):
    '''查询历史的已拒绝的预约数据 [普通用户][管理员]
    userId = ? && usage_date < now && status = 2
    '''
    return get_reserve_data_by_option(request, Data_Status.BEFORE, Reserve_Status.REJECTED, False)


@login_required
def update_reserve_status(request):
    response = {}
    try:
        data = json.loads(request.body)
        reserve = Reserve.objects.get(id=data.get("id"))
        reserve.status = data.get("status")
        if reserve.status == Reserve_Status.CANCELLED.value or reserve.status == Reserve_Status.REJECTED.value:
            reserve.cancel_time = time.strftime(
                '%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
            reserve.cancel_by = request.user.id
        reserve.save()
        response['return_msg'] = "修改成功"
        response['return_code'] = "success"
    except Exception as error:
        response['return_msg'] = "修改失败"
        response['return_code'] = "fail"
        response["error_msg"] = str(error)
    return JsonResponse(response)


def get_reserve_data_by_option(request, data_status, reserve_status, is_admin):
    '''通过条件查询预约数据

    普通用户：查询用户(userId=?)提交的所有未审核(status=0)的预约申请
    管理员：查询出今天及之后14天内的用户提交的未审核(status=0)的预约申请，进行分页查询，每页20


    Args:
        request: 前端的请求，获取里面的json参数
            {
                "status":?,
                "userId":"用户id（用户需要）",
                "startDate":"开始日期，例如2020-12-05（管理员权限）",
                "endDate":"结束日期（管理员权限）",
                "pageNo":"第几页",
                "pageSize":"每页数据量"
            }

    Returns:
        {
            "return_msg":[
                {
                    "username":"生科院",
                    "usage_start_time":"开始时间",
                    "usage_end_time":"结束时间",
                    "usage_reason":"理由",
                    "reserve_time":"提交预约的时间",
                },
                {
                    "username":"信息院",
                    "usage_start_time":"开始时间",
                    "usage_end_time":"结束时间",
                    "usage_reason":"理由",
                    "reserve_time":"提交预约的时间",
                }
            ],
            "return_code":"失败或成功",
            "error_msg":"错误信息（出错时）"
        }
    '''

    response = {}

    try:
        data = json.loads(request.body)

        if data.get("count") != None:
            return getDataCount(request, data_status, reserve_status, is_admin)

        pageNo = data.get("pageNo")
        pageSize = data.get("pageSize")

        sql = 'select \
            reserve_reserve.id id, \
            auth_user.username username, \
            place_place.name place, \
            reserve_reserve.status status, \
            contact_man_name contactManName, \
            contact_man_telephone contactManTelephone, \
            date_format(usage_start_time, "%H:%i") usageStartTime, \
            date_format(usage_end_time, "%H:%i") usageEndTime, \
            usage_reason usageReason, \
            date_format(reserve_time, "%Y-%c-%d %H:%i:%s") reserveTime, \
            usage_date usageDate \
                from reserve_reserve, auth_user, place_place \
            where {} {} \
                and reserve_reserve.user_id = auth_user.id \
                and reserve_reserve.place_id = place_place.id \
                {} {} order by CONCAT(usage_date+" ", date_format(usage_start_time, "%H:%i:%s")) desc limit {},{}'.format(
                    get_status_sql(reserve_status),
                    get_place_sql(request.user),
                    get_user_sql(request.user, is_admin),
                    get_date_sql(data_status),
                    pageNo * pageSize,
                    pageSize)

        cursor = connection.cursor()
        cursor.execute(sql)
        ret = fetch_dict_result(cursor)
        response['return_msg'] = ret
        response['return_code'] = 'success'

    except Exception as e:
        response['return_msg'] = '获取数据失败'
        response['return_code'] = 'fail'
        response['error_msg'] = str(e)

    return JsonResponse(response)

def getDataCount(request, data_status, reserve_status, is_admin):
    response = {}
    try:
        sql = 'select \
            count(*) \
                    from reserve_reserve, auth_user, place_place \
                where {} {} \
                    and reserve_reserve.user_id = auth_user.id \
                    and reserve_reserve.place_id = place_place.id \
                    {} {}'.format(
                        get_status_sql(reserve_status),
                        get_place_sql(request.user),
                        get_user_sql(request.user, is_admin),
                        get_date_sql(data_status))
        cursor = connection.cursor()
        cursor.execute(sql)
        ret = cursor.fetchall()
        response['return_msg'] = ret
        response['return_code'] = 'success'
    except Exception as e:
        response['return_msg'] = '获取数据失败'
        response['return_code'] = 'fail'
        response['error_msg'] = str(e)
    return JsonResponse(response)



def get_user_sql(user, is_admin):
    '''获取不同用户类型的sql条件
    '''
    user_str = ""
    if is_admin:
        if user.is_staff == False:
            raise Exception("没有权限!")
    else:
        user_str = 'and auth_user.id = {}'.format(user.id)
    return user_str

def get_place_sql(user):
    '''获取用户所属场地的sql条件
    '''
    place_str = ""
    if user.is_superuser == False:
        place_str = "and FIND_IN_SET(reserve_reserve.place_id, '{}')".format(user.place_id_list)

    return place_str

def get_status_sql(statusType):
    '''获取不同状态的数据的sql条件
    '''
    status_str = "reserve_reserve.status = {}".format(statusType.value)
    if statusType == Reserve_Status.CANCELLED:
        status_str = "reserve_reserve.status != {}".format(statusType.value)
    return status_str


def get_date_sql(dataType):
    '''获取不同时间段的数据的sql条件
    '''
    if dataType == Data_Status.ALL:
        return ''

    now = time.strftime("%Y-%m-%d", time.localtime())

    if dataType == Data_Status.AFTER:
        return 'and usage_date > "{}"'.format(now)

    if dataType == Data_Status.BEFORE:
        return 'and usage_date < "{}"'.format(now)
