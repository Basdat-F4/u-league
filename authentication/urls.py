from django.urls import path
from authentication.views import *;

app_name = 'authentication'

urlpatterns = [
    path('', homepage, name='login-and-register'),
    path('login/', login, name='login'),
    path('logout/', logout, name='logout'),
    path('register-manajer/', register_manajer, name='register_manajer'),
    path('register-panitia/', register_panitia, name='register-panitia'),
    path('register-penonton/', register_penonton, name='register-penonton')
]