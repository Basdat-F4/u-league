from django.shortcuts import render
from utils.query import query

# Create your views here.
def tes_tim(request):
    return render(request, "tim.html")

def tes_pelatih(request):
    return render(request, "pelatih.html")

def tes_pemain(request):
    return render(request, "pemain.html")

def tes_daftar(request):
    return render(request, "pendaftaran-tim.html")

# Create your views here.
def get_team(request):
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
