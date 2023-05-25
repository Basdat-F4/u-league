from django.shortcuts import render
from django.db import connection
from utils.query import query as execute_query  # Rename the locally defined function

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
    nama_tim_result = 'As Roma'
        
    if len(nama_tim_result) > 0:
        nama_tim = nama_tim_result[0][0]
        
        res = query(f"""
        SELECT
            CONCAT(pemain.Nama_Depan, ' ', pemain.Nama_Belakang) AS Nama_Pemain,
            pemain.Nomor_HP,
            pemain.Tgl_Lahir,
            pemain.Is_Captain,
            pemain.Posisi,
            pemain.NPM,
            pemain.Jenjang
        FROM
            pemain
        WHERE Nama_Tim='{nama_tim}'
        """)

        ult = query(f"""
        SELECT 
            CONCAT(non_pemain.Nama_Depan, ' ', non_pemain.Nama_Belakang) AS Nama_Pelatih,
            non_pemain.Nomor_HP,
            non_pemain.Email,
            non_pemain.Alamat,
            Spesialisasi_Pelatih.Spesialisasi,
            Pelatih.Nama_Tim
        FROM Pelatih
        JOIN non_pemain ON Pelatih.ID_Pelatih = non_pemain.ID
        JOIN Spesialisasi_Pelatih ON Pelatih.ID_Pelatih = Spesialisasi_Pelatih.ID_Pelatih
        WHERE Nama_Tim='{nama_tim}'
        """)

        context = {"pemain_list": res, "pelatih_list": ult}

        return render(request, "tim.html", context)
