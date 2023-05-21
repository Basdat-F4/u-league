from django.urls import path
from tiket.views import *

app_name = 'tiket'

urlpatterns = [
 path('list-stadium/', get_stadium_date, name="get_stadium_date"),
 path('list-time/', get_time, name="get_time"),
 path('list-game/', get_game, name='get_game'),
 path('beli/', ticket_buy, name='ticket_buy')
]