from django.urls import path
from team.views import tes_daftar, tes_pelatih, tes_pemain, get_team, get_pemain_names

app_name = 'team'

urlpatterns = [
    path('', get_team, name='tes_tim'),
    path('pelatih', tes_pelatih, name='reg_pelatih'),
    path('pemain', reg_pemain, name='reg_pemain'),
    path('daftar', tes_daftar, name='tes_daftar'),
]