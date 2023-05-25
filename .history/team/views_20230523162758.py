from django.shortcuts import render

# Create your views here.
def show_wishlist(request):
    return render(request, "wishlist.html")
