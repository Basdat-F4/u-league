from django.urls import path
from authentication.views import homepage, login;

app_name = 'authentication'

urlpatterns = [
    path('', homepage, name='login-and-register'),
    path('login/', login, name='login'),

]