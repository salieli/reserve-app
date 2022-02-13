from django.db import models

class Reserve(models.Model):
    user_id = models.IntegerField()
    place_id = models.IntegerField()
    usage_start_time = models.TimeField()
    usage_end_time = models.TimeField()
    usage_date = models.DateField()
    usage_reason = models.CharField(max_length=300)
    contact_man_name = models.CharField(max_length=10)
    contact_man_telephone = models.CharField(max_length=11)
    reserve_time = models.DateTimeField(auto_now_add=True)
    cancel_time = models.DateTimeField(blank=True, null=True)
    cancel_by = models.IntegerField(default=0)
    status = models.IntegerField(default=0)

    def __str__(self):
        return self.usage_reason
