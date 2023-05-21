from django.shortcuts import render, redirect
from utils.query import query
from django.views.decorators.csrf import csrf_exempt
import random
import uuid

# Create your views here.

forms = {}

@csrf_exempt
def get_stadium_date(request):
    res = query(f"SELECT * FROM stadium")
    context = {'stadiums': res}

    if request.method != "POST":
        return render(request, "choose_stadium.html", context)
    
    context = {"isNotValid" : False, "message":"Harap masukan data yang lengkap"}
    
    stadium = request.POST["stadium"]
    tanggal = request.POST["tanggal"]

    context["isNotValid"] = not stadium or not tanggal
    print(context["isNotValid"])

    if(context["isNotValid"]):
        context["stadiums"] = res
        return render(request, "choose_stadium.html", context)
    
    forms['stadium'] = stadium
    forms['tanggal'] = tanggal

    return redirect("/tiket/list-time")

@csrf_exempt
def get_time(request):
    res = query(f""" 
            SELECT concat(TO_CHAR(start_datetime,'HH:MI'), ' - ', TO_CHAR(end_datetime,'HH:MI')) as display, P.start_datetime::text FROM STADIUM S JOIN PERTANDINGAN P 
            ON S.id_stadium = P.stadium 
            WHERE P.stadium = '{forms['stadium']}'
            AND start_datetime::timestamp::date = '{forms['tanggal']}'
            """)
    print(res)
    
    nama_stadium = query(f"SELECT nama FROM STADIUM WHERE id_stadium = '{forms['stadium']}'")[0][0]
    context = {"list_waktu": res, "nama_stadium": nama_stadium}

    if request.method != "POST":
        return render(request, "choose_time.html", context)
    
    waktu = request.POST['waktu']
    forms['waktu'] = waktu

    print(waktu)
    
    return redirect("/tiket/list-game")

@csrf_exempt
def get_game(request):
    res = query(f"""
            SELECT DISTINCT ON (P.id_pertandingan) P.id_pertandingan, A.nama_tim as tim_a, B.nama_tim as tim_b
            FROM PERTANDINGAN P, TIM_PERTANDINGAN A, TIM_PERTANDINGAN B, STADIUM S
            WHERE P.id_pertandingan = A.id_pertandingan
            AND P.id_pertandingan = B.id_pertandingan
            AND S.id_stadium = P.stadium
            AND A.nama_tim != B.nama_tim
            AND P.stadium = '{forms['stadium']}'
            AND P.start_datetime = '{forms['waktu']}'
            GROUP BY P.id_pertandingan, A.nama_tim, B.nama_tim;
            """)
    
    print({forms['stadium']})
    print({forms['waktu']})
    print(res)
    context = {"list_pertandingan": res}

    if request.method != "POST":
        return render(request, "choose_game.html", context)
    
    pertandingan = request.POST['pertandingan']
    forms['pertandingan'] = pertandingan
    
    return redirect("/tiket/beli")

@csrf_exempt
def ticket_buy(request):
    list_jenis = ["VIP", "Main East", "kategori 1", "kategori 2"]
    list_pembayaran = ['Shopeepay', 'Gopay', 'OVO', 'Debit']
    context = {
        'list_jenis': list_jenis,
        'list_pembayaran': list_pembayaran
    }

    if request.method != "POST":
        return render(request, "buy_ticket.html", context)
    
    jenis = request.POST['jenis']
    pembayaran = request.POST['pembayaran']
    
    lists = {}

    username = request.session["username"]
    print(username)
    lists['id_penonton'] = query(f"SELECT id_penonton FROM PENONTON WHERE username = '{username}'")[0][0]
    print(lists['id_penonton'])
    lists['pertandingan'] = forms["pertandingan"]
    lists['jenis'] = jenis
    lists['pembayaran'] = pembayaran
    lists['receipt'] = uuid.uuid1(random.randint(0, 281474976710655))

    res = query(f"""INSERT INTO PEMBELIAN_TIKET VALUES 
        ('{lists['receipt']}', '{lists['id_penonton']}', '{lists['jenis']}', '{lists['pembayaran']}', '{lists['pertandingan']}') """)
    
    print(res)
    return redirect("/")
    