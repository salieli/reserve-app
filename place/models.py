# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.db import models
import datetime


class Place(models.Model):
    name = models.CharField(max_length=20)
    add_time = models.DateTimeField(default=datetime.datetime.now)
    is_delete = models.BooleanField(default=False)
    delete_time = models.DateTimeField(blank=True, null=True)
    add_by = models.IntegerField(default=0)
    delete_by = models.IntegerField(default=0)
    def __str__(self):
        return self.name

class Place_Permission(models.Model):
    user_id =  models.IntegerField()
    place_id_list = models.CharField(max_length=50)
    add_time = models.DateTimeField(default=datetime.datetime.now)
    update_time = models.DateTimeField(default=datetime.datetime.now)