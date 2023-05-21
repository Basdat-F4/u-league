from django.urls import path
from pertandingan.views import *

app_name = 'pertandingan'

urlpatterns = [
 path('list-pertandingan', get_game, name='get_game'),
]