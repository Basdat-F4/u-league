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

def create_peminjaman(request):
    if request.method != "POST":
        list_stadium = query(f"SELECT * FROM stadium")
        list_waktu = []
        if request.GET.get('id_stadium') and request.GET.get('date'):
            list_waktu 
        return render(request, 'peminjaman_stadium/peminjaman-stadium-form.html', {"list_stadium": list_stadium})

    username = request.session["username"]
    id_manajer = query(f"SELECT id_manajer FROM manajer WHERE username={username}")
    start_datetime = str(request.POST["start_datetime"])
    end_datetime = str(request.POST["end_datetime"])
    id_stadium = str(request.POST["id_stadium"])
    insert_response = query(f"INSERT INTO peminjaman VALUES ({id_manajer}, {start_datetime}, {end_datetime}, {id_stadium})")
    
    query("CREATE")

def get_list_waktu(id_stadium, date):
    occupied_times =  query(f"SELECT EXTRACT(hour from start_datime) as hour start_date, end_date FROM peminjaman WHERE start_date::date={date} AND id_stadium={id_stadium}")
    print(occupied_times)
    return occupied_times
