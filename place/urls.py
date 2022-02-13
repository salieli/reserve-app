from django.urls import path
from .import views

app_name = "place"
urlpatterns = [
    path("add", views.add_place, name="place_add"),
    path("delete", views.delete_place, name="place_delete"),
    path("all", views.get_all_place, name="place_get_all"),
    path("list", views.get_place_list, name="get_place_list"),
]