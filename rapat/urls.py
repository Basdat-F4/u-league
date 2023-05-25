from django.urls import path
from rapat.views import *

app_name = 'rapat'

urlpatterns = [
 path('history-rapat', get_history, name='get_history'),
 path('mulai-rapat', start_rapat, name='mulai_rapat'),
 path('rapat-form', rapat_form, name='rapat_form'),
 path('create-rapat', create_rapat, name='create_rapat'),
]