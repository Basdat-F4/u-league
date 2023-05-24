from django.urls import path
from peminjaman_stadium.views import *

app_name = 'peminjaman_stadium'

urlpatterns = [
 path('list', get_list_peminjaman, name='get_list_peminjaman'),
]