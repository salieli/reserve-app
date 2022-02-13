from django.db import models

class Content(models.Model):
    data_type = models.IntegerField()
    data_content = models.TextField()
    add_time = models.DateTimeField(auto_now_add=True)
    update_time = models.DateTimeField(auto_now_add=True)
    is_used = models.BooleanField(default=False)