from django.urls import path
from authentication.views import *;

app_name = 'authentication'

urlpatterns = [
    path('', homepage, name='login-and-register'),
    path('login/', login, name='login'),
    path('logout/', logout, name='logout'),
    path('register/', register_view, name="register_view"),
    path('register-manajer/', register_manajer, name='register_manajer'),
    path('register-panitia/', register_panitia, name='register-panitia'),
    path('register-penonton/', register_penonton, name='register-penonton'),
    path('dashboard-penonton/', show_penonton_data, name='show_penonton_data'),
    path('dashboard-manajer/', show_manajer_data, name='show_manajer_data'),
    path('dashboard-panitia/', show_panitia_data, name='show_panitia_data'),

]