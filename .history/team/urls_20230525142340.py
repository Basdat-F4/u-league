from django.urls import path
from team.views import get_team, reg_pelatih, reg_pemain, team, set_captain, delete_player, delete_coach, insert_pelatih, insert_pemain, register_team

app_name = 'team'

urlpatterns = [
    path('', team, name='team'),
    path('get_team', get_team, name='get_team'),
    path('pelatih', reg_pelatih, name='reg_pelatih'),
    path('pemain', reg_pemain, name='reg_pemain'),
    path('set_captain/<int:player_id>/', set_captain, name='set_captain'),
    path('set_captain/<uuid:player_id>/', set_captain, name='set_captain'),
    path('delete_player/<uuid:player_id>/', delete_player, name='delete_player'),
    path('delete_coach/<uuid:pelatih_id>/', delete_coach, name='delete_coach'),
    path('insert_pelatih', insert_pelatih, name='insert_pelatih'),
    path('insert_pemain/', insert_pemain, name='insert_pemain'),
    path('register_team', register_team, name='register_team' )
]
