from django.shortcuts import render
from utils.query import query
from django.db import connection

# Create your views here.
def tes_tim(request):
    return render(request, "tim.html")

def tes_pelatih(request):
    return render(request, "pelatih.html")

def tes_pemain(request):
    return render(request, "pemain.html")

def tes_daftar(request):
    return render(request, "pendaftaran-tim.html")

def get_team(request):
    with connection.cursor() as cursor:
        cursor.execute(f"""
    SELECT
        CONCAT(pemain.nama_depan, ' ', pemain.nama_belakang) AS Nama_Pemain,
        pemain.nomor_hp,
        pemain.tgl_lahir,
        pemain.is_captain,
        pemain.posisi,
        pemain.npm,
        pemain.jenjang
    FROM
        pemain
    WHERE nama_tim='AS Roma'
    GROUP BY Nama_Pemain,
        pemain.nomor_hp,
        pemain.tgl_lahir,
        pemain.is_captain,
        pemain.posisi,
        pemain.npm,
        pemain.jenjang
    """)
        pemain_raw = cursor.fetchall()

        pemain_list = []

        for res in pemain_raw:
            pemain_list.append(
                {
                    "nama_pemain": res[0],
                    "nomor_hp": res[1],
                    "tgl_lahir": res[2],
                    "is_captain": res[3],
                    "posisi": res[4],
                    "npm": res[5],
                    "jenjang": res[6],
                }
            )

        cursor.execute(f"""
#     SELECT CONCAT(Non_Pemain.Nama_Depan, ' ', Non_Pemain.Nama_Belakang) AS Nama, Non_Pemain.Nomor_HP, Non_Pemain.Email, Non_Pemain.Alamat, Spesialisasi_Pelatih.Spesialisasi, Pelatih.Nama_Tim
# FROM Pelatih
# JOIN Non_Pemain ON Pelatih.ID_Pelatih = Non_Pemain.ID
# JOIN Spesialisasi_Pelatih ON Pelatih.ID_Pelatih = Spesialisasi_Pelatih.ID_Pelatih
# WHERE Nama_Tim = 'AS Roma'
#     """)
        pelatih_raw = cursor.fetchall()

        pemain_list = []

        for res in pemain_raw:
            pemain_list.append(
                {
                    "nama_pemain": res[0],
                    "nomor_hp": res[1],
                    "tgl_lahir": res[2],
                    "is_captain": res[3],
                    "posisi": res[4],
                    "npm": res[5],
                    "jenjang": res[6],
                }
            )

        context = {
            "pemain_list": pemain_list
        }

        return render(request, "tim.html", context)

# def query(sql_query):
#     # Assuming you are using a database library like Django's ORM or psycopg2
#     with connection.cursor() as cursor:
#     # Execute the query and fetch all the results
#         cursor.execute(sql_query)
#         results = cursor.fetchall()

#     # Return the results
#     return results

# def get_team(request):
#     # username = request.session["username"]
#     username = 'jharken0'
#     # nama_tim_result = query(f"SELECT tm.Nama_Tim FROM Tim_Manajer tm JOIN manajer m ON tm.ID_Manajer = m.ID_Manajer WHERE m.Username = '{username}'")
#     nama_tim = 'As Roma'
#         # nama_tim = nama_tim_result[0][0]

#     res = query(f"""
#     SELECT
#         CONCAT(pemain.nama_depan, ' ', pemain.nama_belakang) AS Nama_Pemain,
#         pemain.nomor_hp,
#         pemain.tgl_lahir,
#         pemain.is_captain,
#         pemain.posisi,
#         pemain.npm,
#         pemain.jenjang
#     FROM
#         pemain
#     WHERE nama_tim='AS Roma'
#     GROUP BY Nama_Pemain,
#         pemain.nomor_hp,
#         pemain.tgl_lahir,
#         pemain.is_captain,
#         pemain.posisi,
#         pemain.npm,
#         pemain.jenjang
#     """)

#     ult = query(f"""
#     SELECT CONCAT(Non_Pemain.Nama_Depan, ' ', Non_Pemain.Nama_Belakang) AS Nama, Non_Pemain.Nomor_HP, Non_Pemain.Email, Non_Pemain.Alamat, Spesialisasi_Pelatih.Spesialisasi, Pelatih.Nama_Tim
# FROM Pelatih
# JOIN Non_Pemain ON Pelatih.ID_Pelatih = Non_Pemain.ID
# JOIN Spesialisasi_Pelatih ON Pelatih.ID_Pelatih = Spesialisasi_Pelatih.ID_Pelatih
# WHERE Nama_Tim = 'AS Roma'
#     """)

#     print(res)
#     print(ult)

#     context = {"pemain_list": res, "pelatih_list": ult}

#     return render(request, "tim.html", context)

