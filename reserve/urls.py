from django.urls import path
from . import views

urlpatterns = [
    path('submitreservedata', views.submit_reserve_data),
    path('getreservedata',views.get_reserve_data),
    path('getallauditing',views.get_all_auditing),
    path('getallpassed',views.get_all_passed),
    path('getallrejected',views.get_all_rejected),
    path('getnow',views.get_now),
    path('gethistorypassed',views.get_history_passed),
    path('gethistoryrejected',views.get_history_rejected),
    path('updatereservestatus',views.update_reserve_status)
]
