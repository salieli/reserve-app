from django.conf.urls import url, include
from django.contrib import admin
from django.views.generic import TemplateView
from django.conf.urls import handler404, handler500
from django.urls import path
from django.views import static  # 新增
from django.conf import settings  # 新增
from django.conf.urls import url  # 新增
import account.urls
import account.views
import reserve.urls
import reserve.views
import content.urls
import content.views
import place.urls
import place.views

handler404 = "account.views.page_not_found"
handler500 = "account.views.page_error"

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/place/", include(place.urls)),
    path("api/account/", include(account.urls)),
    path("api/reserve/", include(reserve.urls)),
    path("api/content/", include(content.urls)),
    url(r'^$',  reserve.views.index),
    url(r'^login$', account.views.login),
    url(r'^place$', place.views.index),
    url(r'^user$', account.views.user),
    url(r'^submitreserve$', reserve.views.submitreserve),
    url(r'^reserve$', reserve.views.checkreserve),
    url(r'^viewreserve$', reserve.views.viewreserve),
    url(r'^homeedit$', content.views.homeedit),
    url(r'^static/(?P<path>.*)$', static.serve,
        {'document_root': settings.STATIC_ROOT}, name='static')
      
]