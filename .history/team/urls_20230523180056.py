from django.urls import path
from team.views import tes_tim

app_name = 'wishlist'

urlpatterns = [
    path('', tes_tim, name='tes_tim'),
    path('', tes_tim, name='tes_tim'),
]