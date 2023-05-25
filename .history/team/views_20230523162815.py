from django.shortcuts import render

# Create your views here.
def tes_html(request):
    return render(request, "tim.html")
