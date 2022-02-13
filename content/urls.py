from django.urls import path
from . import views

app_name = "content"
urlpatterns = [
    path("", views.homeedit, name="content_homeedit"),
    path("add", views.add, name= "content_add"),
    path("update", views.update, name= "content_update"),
    path("all", views.all, name= "content_all"),
    path("uploadimage", views.upload_image, name= "content_upload_image"),
    path("deleteimage", views.delete_image, name= "content_delete_image"),
]