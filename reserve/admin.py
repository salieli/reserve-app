from django.contrib import admin
from .models import Reserve

class ReserveAdmin(admin.ModelAdmin):
    fieldsets = [
        (None,{"fields":['place_id','usage_start_time','usage_end_time','status']}),
    ]
    list_display = ('user_id','place_id','usage_start_time','usage_end_time','usage_reason','status')
    list_filter = ['reserve_time',]
    
#admin.site.register(Reserve,ReserveAdmin)