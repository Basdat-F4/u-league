from django.shortcuts import render

from django.shortcuts import render, redirect
from utils.query import query
from datetime import datetime, date, time

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
        id_stadium = request.GET.get('id_stadium')
        date = request.GET.get('date')
        if id_stadium is not None and date is not None :
            list_waktu = get_list_waktu(id_stadium, date)

        return render(request, 'peminjaman_stadium/peminjaman-stadium-form.html', {"list_stadium": list_stadium, "list_waktu": list_waktu, "id_stadium": id_stadium, "date": date})

    username = request.session["username"]
    id_manajer = query(f"SELECT id_manajer FROM manajer WHERE username='{username}'")[0][0]
    start_datetime = str(request.POST["start_datetime"])
    end_datetime = str(request.POST["end_datetime"])
    id_stadium = str(request.POST["id_stadium"])
    insert_response = query(f"INSERT INTO peminjaman VALUES ('{id_manajer}', '{start_datetime}', '{end_datetime}', '{id_stadium}')")
    print(insert_response)
    return redirect("/peminjaman_stadium/list")
    

def get_list_waktu(id_stadium, datestr):
    occupied_times =  query(f"SELECT start_datetime, end_datetime FROM peminjaman WHERE start_datetime::date='{datestr}' AND id_stadium='{id_stadium}'")
    available_times = []
    duration = 2 # 2 hours
    book_date = datetime.combine(date.fromisoformat(datestr), time.min)

    for hour in range(0, 24-duration, duration):
        start_time = book_date.replace(hour=hour, minute=0)
        end_time = start_time.replace(hour=hour+duration)
        if any(is_date_overlap((start_time, end_time), (r.start_datetime, r.end_datetime)) for r in occupied_times ):
            continue
        available_times.append({"start_datetime": start_time, "end_datetime": end_time})
    print(occupied_times)
    return available_times

def is_date_overlap(rangeDate1, rangeDate2):
    return rangeDate1[0] <= rangeDate2[1] and rangeDate1[1] >= rangeDate2[0]