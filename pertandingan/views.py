from django.shortcuts import render

from utils.query import query

# Create your views here.
def get_game(request):
    res = query(f"""
            SELECT DISTINCT ON (P.id_pertandingan) P.id_pertandingan, A.nama_tim as tim_a, B.nama_tim as tim_b, S.nama as stadium, concat(TO_CHAR(P.start_datetime::timestamp::date, ' DD Month YYYY'), ', ', TO_CHAR(start_datetime,'HH:MI'), ' - ', TO_CHAR(end_datetime,'HH:MI')) as display  
            FROM PERTANDINGAN P, TIM_PERTANDINGAN A, TIM_PERTANDINGAN B, STADIUM S
            WHERE P.id_pertandingan = A.id_pertandingan
            AND P.id_pertandingan = B.id_pertandingan
            AND S.id_stadium = P.stadium
            AND A.nama_tim != B.nama_tim
            GROUP BY P.id_pertandingan, A.nama_tim, B.nama_tim, S.nama;
            """)
    
    context = {"list_pertandingan": res}

    if (request.session["role"] == 'manajer'):
        return render(request, "list_pertandingan_manajer.html", context)
    else:
        return render(request, "list_pertandingan_penonton.html", context)

def list_pertandingan_panitia(request):
    jenis_grup = "ABCDEFGH"
    tim_bertanding = query(f"""
            SELECT DISTINCT a.nama_tim AS tim_a, b.nama_tim AS tim_b
            FROM TIM a, TIM b, TIM_PERTANDINGAN tp
            WHERE a.nama_tim = tp.nama_tim AND b.nama_tim = tp.nama_tim
            """)

    context = {"list_pertandingan_panitia": res}

    if (request.session["role"] == 'panitia'):
        return render(request, "list_pertandingan_panitia.html", context)

def pembuatan_pertandingan(request):
    if (request.session["role"] == 'panitia'):
        return render(request, "list_pertandingan_panitia.html", context)

    if request.method =="POST":
        stadium = request.POST.get('stadium')

def pendaftaran_pertandingan(request):
    if (request.session["role"] == 'panitia'):
        return render(request, "list_pertandingan_panitia.html", context)

    if request.method == "POST":
        wasit_utama = request.POST.get('wasit_utama')
        wasit_pembantu_satu = request.POST.get('wasit_pembantu_satu')
        wasit_pembantu_dua = request.POST.get('wasit_pembantu_dua')
        wasit_cadangan = request.POST.get('wasit_cadangan')

        res = query(f"INSERT INTO PERTANDINGAN VALUE")
        # pertandingan --> ID_Pertandingan, StartDatetime, EndDatetime, Stadium
def list_waktu_stadium(request):
    return request

def list_pertandingan(request):
    return request
    
    
