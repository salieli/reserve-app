from django.urls import path
from . import views

app_name = "account"
urlpatterns = [
    path("", views.hello, name="user_hello"),
    path("login", views.user_login, name="user_login"),
    path("logout", views.user_logout, name="user_logout"),
    path("add", views.add_user, name= "user_add"),
    path("delete", views.delete_user, name = "user_delete"),
    path("changepassword", views.change_password, name = "user_changepassword"),
    path("resetpassword", views.reset_password, name = "user_resetpassword"),
    path("all", views.get_all_user, name="user_all"),
    path("user", views.get_user, name="get_user"),
    path("authorize", views.authorize, name="authorize"),
]