from django.urls import path
from team.views import tes_tim, tes_daftar, tes_pelatih, tes_pemain

app_name = 'wishlist'

urlpatterns = [
    path('tim', tes_tim, name='tes_tim'),
    path('pelatih', tes_pelatih, name='tes_pelatih'),
    path('pemain', tes_pemain, name='tes_pemain'),
]