from django.contrib import admin
from .models import Place

class PlaceAdmin(admin.ModelAdmin):
    fieldsets = [
        (None,{"fields":['name',]}),
    ]
    list_display = ('name','add_time','is_delete')
    list_filter = ['add_time',]
    search_fields = ['name',]
 
admin.site.register(Place,PlaceAdmin)