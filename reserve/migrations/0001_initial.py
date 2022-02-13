# Generated by Django 3.1.3 on 2020-12-05 09:09

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Reserve',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('user_id', models.IntegerField()),
                ('place_id', models.IntegerField()),
                ('usage_start_time', models.TimeField()),
                ('usage_end_time', models.TimeField()),
                ('usage_date', models.DateField()),
                ('usage_reason', models.CharField(max_length=60)),
                ('reserve_time', models.DateTimeField(auto_now_add=True)),
                ('cancel_time', models.DateTimeField(blank=True, null=True)),
                ('status', models.IntegerField(default=0)),
            ],
        ),
    ]
