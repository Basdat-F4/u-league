from django.shortcuts import render, redirect
from utils.query import query
from django.db import connection
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db import IntegrityError
from django.contrib import messages

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
        return render(request, 'pendaftaran-tim.html')
    
def register_team(request):
    if request.method == 'POST':
        nama_tim = request.POST.get('name')
        universitas = request.POST.get('univ')

        username = request.session["username"]
        manager_id_result = query(f"SELECT m.id_manajer FROM manajer m WHERE m.Username = '{username}'")
        manager_id = manager_id_result[0].id_manajer

        with connection.cursor() as cursor:
            # Check if the manager already has a team
            cursor.execute("""
                SELECT COUNT(*) FROM tim_manajer tm
                INNER JOIN manajer m ON tm.id_manajer = m.id_manajer
                WHERE m.username = %s
            """, [username])
            team_count = cursor.fetchone()[0]

            if team_count > 0:
                return redirect('team:get_team')
            else:
                # Create a new team for the manager
                cursor.execute("""
                    INSERT INTO tim (nama_tim, universitas)
                    VALUES (%s, %s)
                """, [nama_tim, universitas])

                cursor.execute("""
                    INSERT INTO tim_manajer (id_manajer, nama_tim)
                    VALUES (%s, %s)
                """, [manager_id, nama_tim])

        return redirect('team:get_team')

    return render(request, 'pendaftaran-tim.html')

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
                    "id": res[0],
                    "nama_pelatih": res[1],
                    "nomor_hp": res[2],
                    "email": res[3],
                    "alamat": res[4],
                    "spesialisasi": res[5],
        
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

def reg_pelatih(request, error_message=None):
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
        'pelatih_options': pelatih_options,
        'error_message': error_message  # Pass the error message to the template context
    }

    return render(request, 'pelatih.html', context)


def insert_pemain(request):
    username = request.session["username"]
    nama_tim_result = query(f"SELECT tm.Nama_Tim FROM Tim_Manajer tm JOIN manajer m ON tm.ID_Manajer = m.ID_Manajer WHERE m.Username = '{username}'")
    nama_tim = nama_tim_result[0].nama_tim

    if request.method == 'POST':
        selected_pemain_nama = request.POST.get('pemain')

        with connection.cursor() as cursor:
            cursor.execute("SET SEARCH_PATH TO 'u-league'")

            # Get the selected pemain information from the database
            cursor.execute("""
                SELECT Pemain.ID_Pemain
                FROM Pemain
                WHERE CONCAT(pemain.nama_depan, ' ', pemain.nama_belakang) = %s
                    AND Pemain.Nama_Tim IS NULL
            """, [selected_pemain_nama])

            pemain_info = cursor.fetchone()

            if pemain_info:
                pemain_id = pemain_info[0]

                cursor.execute(f"UPDATE Pemain SET Nama_Tim='{nama_tim}' WHERE ID_Pemain = '{pemain_id}'")
                print("Pemain inserted into the team")

    return redirect('team:get_team')

from django.db import IntegrityError

from django.db import IntegrityError


def insert_pelatih(request):
    error_message = None  # Initialize the error message variable
    username = request.session["username"]
    nama_tim_result = query(f"SELECT tm.Nama_Tim FROM Tim_Manajer tm JOIN manajer m ON tm.ID_Manajer = m.ID_Manajer WHERE m.Username = '{username}'")
    nama_tim = nama_tim_result[0].nama_tim

    if request.method == 'POST':
        selected_pelatih_nama = request.POST['pelatih']

        with connection.cursor() as cursor:
            try:
                cursor.execute("SET SEARCH_PATH TO 'u-league'")

                # Get the selected pelatih information from the database
                cursor.execute("""
                    SELECT Pelatih.ID_Pelatih, Spesialisasi
                    FROM Pelatih
                    JOIN Non_Pemain ON Pelatih.ID_Pelatih = Non_Pemain.ID
                    JOIN Spesialisasi_Pelatih ON Pelatih.ID_Pelatih = Spesialisasi_Pelatih.ID_Pelatih
                    WHERE CONCAT(Non_Pemain.Nama_Depan, ' ', Non_Pemain.Nama_Belakang) = %s
                        AND Pelatih.Nama_Tim IS NULL
                """, [selected_pelatih_nama])

                pelatih_info = cursor.fetchone()

                if pelatih_info:
                    pelatih_id, spesialisasi = pelatih_info
                    try:
                        cursor.execute(f"UPDATE Pelatih SET Nama_Tim='{nama_tim}' WHERE id_pelatih = '{pelatih_id}'")
                    except :
                        print("sini g")
                        if "The team already has two coaches" in str(e):
                            error_message = "The team already has two coaches. Cannot add more coaches."
                        else:
                            error_message = "An error occurred while updating the coach: " + str(e)

                        messages.error(request, error_message)  # Add error message to Django messages
                    print("Pelatih inserted into the team")

                else:
                    print("sini g")
                    error_message = "Selected coach is not available or already assigned to a team."
            except IntegrityError as e:
                print("sini g")
                if "The team already has two coaches" in str(e):
                    error_message = "The team already has two coaches. Cannot add more coaches."
                else:
                    error_message = "An error occurred while updating the coach: " + str(e)

                messages.error(request, error_message)  # Add error message to Django messages

    return render(request, 'pelatih.html')

def set_captain(request, player_id):
    with connection.cursor() as cursor:
        cursor.execute("SET SEARCH_PATH TO 'u-league'")

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
