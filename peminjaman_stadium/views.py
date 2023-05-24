from django.shortcuts import render

from django.shortcuts import render, redirect
from utils.query import query

# Create your views here.
def get_list_peminjaman(request):
    username = request.session["username"]
    list_peminjaman = query(f"""
        SELECT start_datetime, end_datetime, s.nama as stadium FROM peminjaman 
        JOIN manajer using (id_manajer)
        JOIN stadium s using (id_stadium) 
        WHERE username='{username}'
        """)
    return render(request, "peminjaman_stadium/peminjaman-stadium.html", {"list_peminjaman": list_peminjaman})