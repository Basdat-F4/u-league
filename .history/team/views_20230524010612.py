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

def query(sql_query):
    # Assuming you are using a database library like Django's ORM or psycopg2
    with connection.cursor() as cursor:
    # Execute the query and fetch all the results
        cursor.execute(sql_query)
        results = cursor.fetchall()

    # Return the results
    return results

def get_team(request):
    # username = request.session["username"]
    username = 'jharken0'
    # nama_tim_result = query(f"SELECT tm.Nama_Tim FROM Tim_Manajer tm JOIN manajer m ON tm.ID_Manajer = m.ID_Manajer WHERE m.Username = '{username}'")
    nama_tim = 'As Roma'
        # nama_tim = nama_tim_result[0][0]

    res = query(f"""
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
    GROUP BY 
    """)

    ult = query(f"""
    SELECT CONCAT(Non_Pemain.Nama_Depan, ' ', Non_Pemain.Nama_Belakang) AS Nama, Non_Pemain.Nomor_HP, Non_Pemain.Email, Non_Pemain.Alamat, Spesialisasi_Pelatih.Spesialisasi, Pelatih.Nama_Tim
FROM Pelatih
JOIN Non_Pemain ON Pelatih.ID_Pelatih = Non_Pemain.ID
JOIN Spesialisasi_Pelatih ON Pelatih.ID_Pelatih = Spesialisasi_Pelatih.ID_Pelatih
WHERE Nama_Tim = 'AS Roma'
    """)

    print(res)
    print(ult)

    context = {"pemain_list": res, "pelatih_list": ult}

    return render(request, "tim.html", context)

