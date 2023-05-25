from django.urls import path
from pertandingan.views import *

app_name = 'pertandingan'

urlpatterns = [
 path('list-pertandingan/', get_game, name='get_game'),
 path('list-pertandingan-panitia/', list_pertandingan_panitia, name='get_pertandingan'),
 path('pendaftaran-pertandingan/<str:stadium_tanggal>', pendaftaran_pertandingan, name='daftar_pertandingan'),
 path('pemilihan-stadium/', pemilihan_stadium, name='pilih_stadium'),
 path('waktu-stadium/', list_waktu_stadium, name='waktu_stadium')
]