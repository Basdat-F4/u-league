from django.urls import path
from team.views import get_team

app_name = 'team'

urlpatterns = [
    path('', get_team, name='tes_tim'),
]