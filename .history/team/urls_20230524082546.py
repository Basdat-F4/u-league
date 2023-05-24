from django.urls import path
from team.views import tes_daftar, get_team, reg_pelatih, reg_pemain

app_name = 'team'

urlpatterns = [
    path('', team, name='team'),
    path('pelatih', reg_pelatih, name='reg_pelatih'),
    path('pemain', reg_pemain, name='reg_pemain'),
    path('daftar', tes_daftar, name='tes_daftar'),
]