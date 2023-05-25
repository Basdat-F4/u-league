from django.urls import path
from peminjaman_stadium.views import *

app_name = 'peminjaman_stadium'

urlpatterns = [
 path('list', get_list_peminjaman, name='get_list_peminjaman'),
 path('create', create_peminjaman, name='create_peminjaman'),
 path('form/<str:mode>', view_peminjaman_form, name='view_peminjaman_form'),
 path('edit', edit_peminjaman, name='edit_peminjaman'),
]