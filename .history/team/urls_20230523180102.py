from django.urls import path
from team.views import tes_tim

app_name = 'wishlist'

urlpatterns = [
    path('tim', tes_tim, name='tes_tim'),
    path('pelatih', tes_tim, name='tes_tim'),
]