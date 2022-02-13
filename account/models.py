from django.contrib.auth.models import AbstractUser
from django.db import models
import datetime

class User(AbstractUser):
    # 扩展系统自带的User
    add_by = models.IntegerField(default=0)
    delete_by = models.IntegerField(default=0)
    delete_time = models.DateTimeField(blank=True, null=True)
    session_key = models.CharField(max_length=32,null=True)
    place_id_list = models.CharField(max_length=200,default='0')

    class Meta:
        db_table = 'auth_user'

class Login_Log(models.Model):
    name = models.CharField(max_length=20)
    login_time = models.DateTimeField(default=datetime.datetime.now)
    ip = models.CharField(max_length=20)
    status = models.CharField(max_length=20)