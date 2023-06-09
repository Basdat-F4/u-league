from django.shortcuts import render, redirect
from utils.query import query
from django.views.decorators.http import require_POST

# Create your views here.
def get_history(request):
    username = request.session["username"]
    id_manajer = query(f"SELECT id_manajer FROM MANAJER WHERE username = '{username}'")[0][0]
    res = query(f"""
            SELECT DISTINCT ON (P.id_pertandingan) P.id_pertandingan, A.nama_tim as tim_a, B.nama_tim as tim_b, S.nama as stadium, concat(TO_CHAR(R.datetime::timestamp::date, ' DD Month YYYY'), ', ', TO_CHAR(R.datetime,'HH:MI')) as display, Concat(N.nama_depan, ' ', N.nama_belakang) as panitia, R.isi_rapat as isi  
            FROM PERTANDINGAN P, TIM_PERTANDINGAN A, TIM_PERTANDINGAN B, STADIUM S, RAPAT R, Non_Pemain N
            WHERE P.id_pertandingan = A.id_pertandingan
            AND P.id_pertandingan = B.id_pertandingan
            AND S.id_stadium = P.stadium
            AND R.id_pertandingan = P.id_pertandingan
            AND N.id = R.perwakilan_panitia
            AND A.nama_tim != B.nama_tim
            AND (R.Manajer_Tim_A = '{id_manajer}' OR R.Manajer_Tim_B = '{id_manajer}')
            GROUP BY P.id_pertandingan, A.nama_tim, B.nama_tim, S.nama, R.datetime, panitia, isi;
            """)
    
    context = {"list_rapat": res}

    return render(request, "history_rapat.html", context)

def start_rapat(request):
    username = request.session["username"]
    id_manajer = query(f"SELECT id_manajer FROM MANAJER WHERE username = '{username}'")
    list_pertandingan = query(f"""
            SELECT DISTINCT ON (P.id_pertandingan) P.id_pertandingan, A.nama_tim as tim_a, B.nama_tim as tim_b, S.nama as stadium, concat(TO_CHAR(P.start_datetime::timestamp::date, ' DD Month YYYY'), ', ', TO_CHAR(start_datetime,'HH:MI'), ' - ', TO_CHAR(end_datetime,'HH:MI')) as display  
            FROM PERTANDINGAN P, TIM_PERTANDINGAN A, TIM_PERTANDINGAN B, STADIUM S
            WHERE P.id_pertandingan = A.id_pertandingan
            AND P.id_pertandingan = B.id_pertandingan
            AND S.id_stadium = P.stadium
            AND A.nama_tim != B.nama_tim
            GROUP BY P.id_pertandingan, A.nama_tim, B.nama_tim, S.nama;
            """)
    context = {"list_pertandingan": list_pertandingan}
    return render(request, "mulai-rapat.html", context)
    
def rapat_form(request):
    id_pertandingan = request.GET.get("id_pertandingan", "")
    pertandingan = query(f"""
            SELECT DISTINCT ON (P.id_pertandingan) P.id_pertandingan, A.nama_tim as tim_a, B.nama_tim as tim_b, S.nama as stadium, concat(TO_CHAR(P.start_datetime::timestamp::date, ' DD Month YYYY'), ', ', TO_CHAR(start_datetime,'HH:MI'), ' - ', TO_CHAR(end_datetime,'HH:MI')) as display  
            FROM PERTANDINGAN P, TIM_PERTANDINGAN A, TIM_PERTANDINGAN B, STADIUM S
            WHERE P.id_pertandingan = A.id_pertandingan
            AND P.id_pertandingan = B.id_pertandingan
            AND S.id_stadium = P.stadium
            AND A.nama_tim != B.nama_tim
            AND P.id_pertandingan = '{id_pertandingan}'
            GROUP BY P.id_pertandingan, A.nama_tim, B.nama_tim, S.nama;
            """)[0]

    context = {"pertandingan": pertandingan}
    return render(request, "rapat-form.html", context)

@require_POST
def create_rapat(request):
    id_pertandingan = request.POST.get("id_pertandingan")
    username = request.session["username"]
    pertandingan = query(f"""
            SELECT DISTINCT ON (P.id_pertandingan) P.id_pertandingan, A.nama_tim as tim_a, B.nama_tim as tim_b, S.nama as stadium, concat(TO_CHAR(P.start_datetime::timestamp::date, ' DD Month YYYY'), ', ', TO_CHAR(start_datetime,'HH:MI'), ' - ', TO_CHAR(end_datetime,'HH:MI')) as display  
            FROM PERTANDINGAN P, TIM_PERTANDINGAN A, TIM_PERTANDINGAN B, STADIUM S
            WHERE P.id_pertandingan = A.id_pertandingan
            AND P.id_pertandingan = B.id_pertandingan
            AND S.id_stadium = P.stadium
            AND A.nama_tim != B.nama_tim
            AND P.id_pertandingan = '{id_pertandingan}'
            GROUP BY P.id_pertandingan, A.nama_tim, B.nama_tim, S.nama;
            """)[0]

    id_panitia = query(f"SELECT id_panitia FROM panitia WHERE username = '{username}'")[0][0]
    id_manajer_tim_a = query(f"SELECT id_manajer FROM tim_manajer WHERE nama_tim='{pertandingan.tim_a}'")[0][0]
    id_manajer_tim_b = query(f"SELECT id_manajer FROM tim_manajer WHERE nama_tim='{pertandingan.tim_b}'")[0][0]
    isi_rapat = request.POST.get("isi_rapat", "")
    res = query(f"""INSERT INTO rapat VALUES ('{id_pertandingan}', NOW(), '{id_panitia}', '{id_manajer_tim_a}', '{id_manajer_tim_b}', '{isi_rapat}')""")
    print(res)
    return redirect("/dashboard-panitia/")