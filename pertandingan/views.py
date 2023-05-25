from django.shortcuts import render
import uuid
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
    tim_bertanding = query(f"""
            SELECT DISTINCT ON (P.id_pertandingan) P.id_pertandingan, A.nama_tim as tim_a, B.nama_tim as tim_b, S.nama as stadium, concat(TO_CHAR(P.start_datetime::timestamp::date, ' DD Month YYYY'), ', ', TO_CHAR(start_datetime,'HH:MI'), ' - ', TO_CHAR(end_datetime,'HH:MI')) as display  
            FROM PERTANDINGAN P, TIM_PERTANDINGAN A, TIM_PERTANDINGAN B, STADIUM S
            WHERE P.id_pertandingan = A.id_pertandingan
            AND P.id_pertandingan = B.id_pertandingan
            AND S.id_stadium = P.stadium
            AND A.nama_tim != B.nama_tim
            GROUP BY P.id_pertandingan, A.nama_tim, B.nama_tim, S.nama;
            """)

    context = {"list_pertandingan_panitia": tim_bertanding}

    #if (request.session["role"] == 'panitia'):
    return render(request, "list_pertandingan_panitia.html", context)

def pemilihan_stadium(request):
    res = query(f"SELECT nama FROM stadium")
    print(res)
    context = {'list_stadium': res}

    if request.method =="POST":
        stadium = request.POST.get('stadium')
        tanggal = request.POST.get('tanggal')

    # if (request.session["role"] == 'panitia'):
    return render(request, "pilih_stadium.html", context)
    
def pendaftaran_pertandingan(request):
    # if request.method == "POST":
    #     wasit_utama = request.POST.get('wasit_utama')
    #     wasit_pembantu_satu = request.POST.get('wasit_pembantu_satu')
    #     wasit_pembantu_dua = request.POST.get('wasit_pembantu_dua')
    #     wasit_cadangan = request.POST.get('wasit_cadangan')
    #     tim_satu = request.POST.get('tim_satu')
    #     tim_dua = request.POST.get('tim_dua')

    id_pertandingan = uuid.uuid4()

    # try:
    # insert_wasit_utama = query(f""""
    #                         INSERT INTO WASIT_BERTUGAS VALUES('{id_wasit}','{id_pertandingan}', '{posisi_wasit}')
    #                         """)

    # insert_wasit_pembantu = query(f"""
    #                             INSERT INTO WASIT_BERTUGAS VALUES('{id_wasit}','{id_pertandingan}', '{posisi_wasit}')
    #                             """)

    # insert_cadangan = query(f"""
    #                     INSERT INTO WASIT_BERTUGAS VALUES('{id_wasit}','{id_pertandingan}', '{posisi_wasit}')
    #                     """)

    # insert_tim_satu = query(f"""
    #             INSERT INTO TIM VALUES('{tim_satu}', '{id_pertandingan}', 0)
    #             """)

    # insert_tim_dua = query(f"""
    #             INSERT INTO TIM VALUES('{tim_dua}', '{id_pertandingan}', 0)
    #             """)

    wasit = query(f"""
                SELECT DISTINCT ON (w.id_wasit) CONCAT(nama_depan, ' ', nama_belakang) AS nama_wasit
                FROM NON_PEMAIN np, WASIT w
                WHERE np.ID = w.id_wasit;
            """)

    #print(wasit)

    tim_res = query(f"""
                SELECT t.nama_tim
                FROM tim t;
            """)

    # res = query(f"""
    #         INSERT INTO PERTANDINGAN VALUES ('{id_pertandingan}', '{start_datetime}', '{end_datetime}', '{stadium}')
    #         """)
    # except Exception as e:
    #     messages.error(request, e)
    
    # context = {"wasit_utama" : wasit, "wasit_pembantu": wasit, "wasit_cadangan": wasit, "tim": tim_res}
    context = {"wasit": wasit, "tim": tim_res}
    #if (request.session["role"] == 'panitia'):
    return render(request, "buat_pertandingan.html", context)

def list_waktu_stadium(request):
    # if request.method == "POST":
    #     stadium = request.POST.get('stadium')
    #     waktu = request.POST.get('waktu')

    stadium = query(f"""SELECT nama FROM STADIUM""")

    waktu = query(f"""
                SELECT p.start_datetime, p.end_datetime
                FROM PERTANDINGAN p
                WHERE DATE(p.start_datetime) = waktu AND p.stadium IN (
                SELECT p.stadium FROM PERTANDINGAN p, STADIUM s
                WHERE p.stadium = s.id_stadium AND s.nama                                                                                                                                               ma = '{stadium}');
            """)

    context = context = {"nama": stadium, "waktu_stadium": waktu}

    # if (request.session["role"] == 'panitia'):
    return render(request, "list_waktu_stadium_panitia.html", context)

    
    
