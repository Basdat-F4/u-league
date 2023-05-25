from django.shortcuts import render, redirect
import uuid
from utils.query import query
from django.contrib import messages

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
    if request.method =="POST":
        stadium = request.POST.get('stadium')
        tanggal = request.POST.get('date')

        stadium_tanggal = str(stadium) + '_' + str(tanggal)

        return redirect(f'/pertandingan/pendaftaran-pertandingan/{stadium_tanggal}')


    res = query(f"SELECT nama, id_stadium FROM stadium")

    context = {'list_stadium': res}


    # if (request.session["role"] == 'panitia'):
    return render(request, "pilih_stadium.html", context)
    
def pendaftaran_pertandingan(request, stadium_tanggal):
    if request.method == "POST":
        wasit_utama = request.POST.get('wasit_utama')
        wasit_pembantu_satu = request.POST.get('wasit_pembantu_1')
        wasit_pembantu_dua = request.POST.get('wasit_pembantu_2')
        wasit_cadangan = request.POST.get('wasit_cadangan')
        tim_satu = request.POST.get('tim_1')
        tim_dua = request.POST.get('tim_2')
        id_stadium = request.POST.get('stadium_tanggal').split("_")[0]
        tanggal = request.POST.get('stadium_tanggal').split("_")[1]

        id_pertandingan = uuid.uuid4()

        print(id_pertandingan)
        print(wasit_utama)
        print(wasit_cadangan)
        print(wasit_pembantu_satu)
        print(wasit_pembantu_dua)
        print(wasit_cadangan)
        print(tim_satu)
        print(tim_dua)
        print(id_stadium)
        print(tanggal)

        try:
            res = query(f"""
        #         INSERT INTO PERTANDINGAN VALUES ('{id_pertandingan}', '{tanggal}', '{tanggal}', '{id_stadium}')
        #         """)
            res = query(f""""
                    INSERT INTO WASIT_BERTUGAS VALUES('{wasit_utama}','{id_pertandingan}', 'utama')
                    """)

            res = query(f"""
                    INSERT INTO WASIT_BERTUGAS VALUES('{wasit_pembantu_satu}','{id_pertandingan}', 'pembantu 1')
                    """)

            res = query(f"""
                    INSERT INTO WASIT_BERTUGAS VALUES('{wasit_pembantu_dua}','{id_pertandingan}', 'pembantu 2')
                    """)
            res = query(f"""
                    INSERT INTO WASIT_BERTUGAS VALUES('{wasit_cadangan}','{id_pertandingan}', 'cadangan')
                    """)

            res = query(f"""
                    INSERT INTO TIM_PERTANDINGAN VALUES('{tim_satu}', '{id_pertandingan}', 0)
                    """)

            res = query(f"""
                    INSERT INTO TIM_PERTANDINGAN VALUES('{tim_dua}', '{id_pertandingan}', 0)
                    """)

            return redirect('/pertandingan/list-pertandingan-panitia/')
        except Exception as e:
            messages.error(request, e)
        

    wasit = query(f"""
                SELECT CONCAT(nama_depan, ' ', nama_belakang) AS nama_wasit, id
                FROM NON_PEMAIN np natural join WASIT w;
            """)

    id_stadium = stadium_tanggal.split("_")[0]
    tanggal = stadium_tanggal.split("_")[1]

    tim_res = query(f"""
                SELECT t.nama_tim
                FROM tim t;
            """)
    
    # context = {"wasit_utama" : wasit, "wasit_pembantu": wasit, "wasit_cadangan": wasit, "tim": tim_res}
    context = {"wasit": wasit, "tim": tim_res, "stadium_tanggal":stadium_tanggal}
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
                WHERE p.stadium = s.id_stadium AND s.nama;                                                                                                                                               ma = '{stadium}');
            """)

    context = {"nama": stadium, "waktu_stadium": waktu}

    # if (request.session["role"] == 'panitia'):
    return render(request, "list_waktu_stadium_panitia.html", context)

def update_query(request):
    up_wasit_utama = query(f"""
                        UPDATE WASIT_BERTUGAS
                        SET id_wasit = wasit_utama, posisi = 'utama'
                        WHERE id_pertandingan = id_pertandingan;
                        """)
    up_wasit_pembantu_satu = query(f"""
                        UPDATE WASIT_BERTUGAS
                        SET id_wasit = wasit_utama, posisi = 'pembantu'
                        WHERE id_pertandingan = id_pertandingan;
                        """)
    up_wasit_pembantu_dua = query(f""" 
                        UPDATE WASIT_BERTUGAS
                        SET id_wasit = wasit_utama, posisi = 'pembantu'
                        WHERE id_pertandingan = id_pertandingan;
                                """)
    up_wasit_cadangan = query(f"""
                        UPDATE WASIT_BERTUGAS
                        SET id_wasit = wasit_utama, posisi = 'cadangan'
                        WHERE id_pertandingan = id_pertandingan;
                                """)
    up_tim1 = query(f""" 
                UPDATE TIM_BERTANDING
                SET nama_tim = nama_tim
                WHERE id_pertandingan = id_pertandingan;
                        """)
    up_tim2 = query(f""" 
                UPDATE TIM_BERTANDING
                SET nama_tim = nama_tim
                WHERE id_pertandingan = id_pertandingan;
                                """)

def delete_query(request):
    del_pertandingan = query("""
                        DELETE FROM PERTANDINGAN
                        WHERE id_pertandingan = id_pertandingan;
                        """)                                

    



    
    
