from django.urls import path
from pertandingan.views import *

app_name = 'pertandingan'

urlpatterns = [
 path('list-pertandingan', get_game, name='get_game'),
 path("list-pertandingan/",get_pertandingan,name="get_pertandingan"),
 path('list_pertandingan_baru/',list_pertandingan_baru,name="list_pertandingan_baru"),
 path('list_peristiwa/',list_peristiwa,name="list_peristiwa"),
]