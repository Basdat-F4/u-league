from django.shortcuts import render, redirect
from utils.query import query
from django.db import connection
from django.contrib.auth.decorators import login_required

# Create your views here

# @login_required
def team(request):
    with connection.cursor() as cursor:
        cursor.execute("SET SEARCH_PATH TO 'u-league'")
        # Get the manager's team information from the database
        cursor.execute("""
            SELECT tm.nama_tim
            FROM tim_manajer tm
            INNER JOIN manajer m ON tm.id_manajer = m.id_manajer
            WHERE m.username = %s
        """, [request.session["username"]])
        team_info = cursor.fetchone()

    if team_info is not None and team_info[0]:
        return get_team(request)
    else:
        return tes_daftar(request)

def tes_daftar(request):
    return render(request, "pendaftaran-tim.html")

def get_team(request):
    username = request.session["username"]
    nama_tim_result = query(f"SELECT tm.Nama_Tim FROM Tim_Manajer tm JOIN manajer m ON tm.ID_Manajer = m.ID_Manajer WHERE m.Username = '{username}'")
    nama_tim = nama_tim_result[0].nama_tim
    with connection.cursor() as cursor:
        cursor.execute("SET SEARCH_PATH TO 'u-league'")
        cursor.execute("""
            SELECT pemain.id_pemain,  CONCAT(pemain.nama_depan, ' ', pemain.nama_belakang) AS Nama_Pemain, pemain.nomor_hp, pemain.tgl_lahir, pemain.is_captain,
            pemain.posisi, pemain.npm, pemain.jenjang
            FROM pemain
            WHERE nama_tim = %s
        """, [nama_tim])
        pemain_raw = cursor.fetchall()

        pemain_list = []

        for res in pemain_raw:
            pemain_list.append({
                "id": res[0],
                "nama_pemain": res[1],
                "nomor_hp": res[2],
                "tgl_lahir": res[3],
                "is_captain": res[4],
                "posisi": res[5],
                "npm": res[6],
                "jenjang": res[7],
            })

        cursor.execute(f"""
    SELECT pelatih.id_pelatih, CONCAT(Non_Pemain.Nama_Depan, ' ', Non_Pemain.Nama_Belakang) AS Nama, Non_Pemain.Nomor_HP, Non_Pemain.Email, Non_Pemain.Alamat, Spesialisasi_Pelatih.Spesialisasi, Pelatih.Nama_Tim
FROM Pelatih
JOIN Non_Pemain ON Pelatih.ID_Pelatih = Non_Pemain.ID
JOIN Spesialisasi_Pelatih ON Pelatih.ID_Pelatih = Spesialisasi_Pelatih.ID_Pelatih
WHERE nama_tim='{nama_tim}'
    """)
        pelatih_raw = cursor.fetchall()

        pelatih_list = []

        for res in pelatih_raw:
            pelatih_list.append(
            
                {
                    "id"
                    "nama_pelatih": res[0],
                    "nomor_hp": res[1],
                    "email": res[2],
                    "alamat": res[3],
                    "spesialisasi": res[4],
        
                }
            )

        # ris = cursor.fetchall()
        print(nama_tim)

        context = {
            "pelatih_list": pelatih_list,
            "pemain_list": pemain_list,
        }

        return render(request, "tim.html", context)

def reg_pemain(request):
    with connection.cursor() as cursor:
        cursor.execute("SET SEARCH_PATH TO 'u-league'")
        cursor.execute("""
            SELECT CONCAT(nama_depan, ' ', nama_belakang) AS Nama_Pemain
            FROM pemain
            WHERE nama_tim IS NULL
        """)
        pemain_names = [res[0] for res in cursor.fetchall()]

    context = {
        "pemain_names": pemain_names
    }

    return render(request, "pemain.html", context)

def reg_pelatih(request):
    with connection.cursor() as cursor:
        cursor.execute("SET SEARCH_PATH TO 'u-league'")
        cursor.execute("""
            SELECT CONCAT(Non_Pemain.Nama_Depan, ' ', Non_Pemain.Nama_Belakang) AS Nama, Spesialisasi_Pelatih.Spesialisasi
            FROM Pelatih
            JOIN Non_Pemain ON Pelatih.ID_Pelatih = Non_Pemain.ID
            JOIN Spesialisasi_Pelatih ON Pelatih.ID_Pelatih = Spesialisasi_Pelatih.ID_Pelatih
            WHERE Pelatih.Nama_Tim IS NULL
        """)
        pelatih_options = [
            {
                'nama_pelatih': res[0],
                'spesialisasi': res[1]
            } for res in cursor.fetchall()
        ]

    context = {
        'pelatih_options': pelatih_options
    }

    return render(request, 'pelatih.html', context)

def set_captain(request, player_id):
    with connection.cursor() as cursor:
        cursor.execute("SET SEARCH_PATH TO 'u-league'")
        cursor.execute(f"SELECT is_captain FROM Pemain WHERE id_pemain = '{player_id}'")
        is_captain = cursor.fetchone()[0]

        if is_captain:
            # The player is already a captain, no action needed
            pass
        else:
            # Remove captain status from existing captain, if any
            cursor.execute(f"UPDATE Pemain SET is_captain = false WHERE Nama_Tim = (SELECT Nama_Tim FROM Pemain WHERE id_pemain = '{player_id}') AND is_captain = true")
            # Assign the player as a captain
            cursor.execute(f"UPDATE Pemain SET is_captain = true WHERE id_pemain = '{player_id}'")

        # Print a message to check if the update query was executed
        print("Player captain updated:", cursor.rowcount)

    return redirect('team:get_team')

def delete_player(request, player_id):
    with connection.cursor() as cursor:
        cursor.execute("SET SEARCH_PATH TO 'u-league'")
        cursor.execute(f"UPDATE Pemain SET Nama_Tim = NULL WHERE id_pemain = '{player_id}'")

        # Print a message to check if the update query was executed
        print("Player removed from team:", cursor.rowcount)

    return redirect('team:get_team')

def delete_coach(request, pelatih_id):
    with connection.cursor() as cursor:
        cursor.execute("SET SEARCH_PATH TO 'u-league'")
        cursor.execute(f"UPDATE Pelatih SET Nama_Tim = NULL WHERE id_pelatih = '{pelatih_id}'")

        # Print a message to check if the update query was executed
        print("Coach removed from team:", cursor.rowcount)

    return redirect('team:get_team')

# Punya orang, review lagi soalnya susah bgt

from collections import namedtuple

def namedtuplefetchall(cursor):
    "Return all rows from a cursor as a namedtuple"
    desc = cursor.description
    nt_result = namedtuple('Result', [col[0] for col in desc])
    return [nt_result(*row) for row in cursor.fetchall()]

def get_query(str):
    '''Execute SQL query and return its result as a list'''
    cursor = connection.cursor()
    result = []
    try:
        cursor.execute(str)
        result = namedtuplefetchall(cursor)
    except Exception as e:
        # print("An exception occurred:", str(e))
        result = e
    finally:
        cursor.close()
        return result

def daftar_sponsor(request):
    # id = str(request.session["id"]).strip()
    id = 'aa8a676a-07a3-4eb6-bcec-54a74ee35c93'

    query = get_query(
        f'''SELECT nama_brand
        FROM sponsor
        WHERE id NOT IN 
        (SELECT id_sponsor FROM atlet_sponsor WHERE id_atlet = '{id}')
        '''
    )
    
    if request.method != "POST":
        return render(request, "daftar_sponsor.html", {"query":query})
    
    nama_brand = request.POST["sponsor"]
    tgl_mulai = request.POST["tgl_selesai"]
    tgl_selesai = request.POST["tgl_selesai"]
    
    id_sponsor = get_query(
        f'''SELECT id
        FROM SPONSOR
        WHERE nama_brand = '{nama_brand}'
        '''
    )
    
    get_query(
        f'''INSERT INTO atlet_sponsor
        VALUES ('{id}', '{id_sponsor[0].id}', '{tgl_mulai}', '{tgl_selesai}');
        '''
    )
    
    query = get_query(
        f'''SELECT nama_brand
        FROM sponsor
        WHERE id NOT IN 
        (SELECT id_sponsor FROM atlet_sponsor WHERE id_atlet = '{id}')
        '''
    )

    return render(request, "daftar_sponsor.html", {"query":query})


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

