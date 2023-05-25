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

def getget

def query(sql_query):
    # Assuming you are using a database library like Django's ORM or psycopg2

    # Execute the query and fetch all the results
    cursor.execute(sql_query)
    results = cursor.fetchall()

    # Return the results
    return results

def get_team(request):
    # username = request.session["username"]
    username = 'jharken0'
    try:
        nama_tim_result = query(f"SELECT tm.Nama_Tim FROM tim_manajer tm JOIN manajer m ON tm.ID_Manajer = m.ID_Manajer WHERE m.Username = '{username}'")
        
        if len(nama_tim_result) > 0:
            nama_tim = nama_tim_result[0][0]
            
            res = query(f"""
            SELECT
                CONCAT(Pemain.Nama_Depan, ' ', Pemain.Nama_Belakang) AS Nama_Pemain,
                Pemain.Nomor_HP,
                Pemain.Tgl_Lahir,
                Pemain.Is_Captain,
                Pemain.Posisi,
                Pemain.NPM,
                Pemain.Jenjang
            FROM
                Pemain
            WHERE Nama_Tim='{nama_tim}'
            """)

            ult = query(f"""
            SELECT 
                CONCAT(Non_Pemain.Nama_Depan, ' ', Non_Pemain.Nama_Belakang) AS Nama_Pelatih,
                Non_Pemain.Nomor_HP,
                Non_Pemain.Email,
                Non_Pemain.Alamat,
                Spesialisasi_Pelatih.Spesialisasi,
                Pelatih.Nama_Tim
            FROM Pelatih
            JOIN Non_Pemain ON Pelatih.ID_Pelatih = Non_Pemain.ID
            JOIN Spesialisasi_Pelatih ON Pelatih.ID_Pelatih = Spesialisasi_Pelatih.ID_Pelatih
            WHERE Nama_Tim='{nama_tim}'
            """)

            context = {"pemain_list": res, "pelatih_list": ult}

            return render(request, "tim.html", context)
        else:
            return HttpResponse("No team found for the given username.")
    except ProgrammingError as e:
        print(f"An error occurred while executing the query: {e}")
        return HttpResponse("An error occurred. Please try again later.")
