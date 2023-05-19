from django.urls import path, include
from authentication.views import homepage;

app_name = 'authentication'

urlpatterns = [
    path('', homepage, name='login-and-register')
]