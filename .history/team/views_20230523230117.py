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
    SELECT
        Pemain.ID_Pemain,
        Pemain.Nama_Tim,
        CONCAT(Pemain.Nama_Depan, ' ', Pemain.Nama_Belakang) AS Nama,
        Pemain.Nomor_HP,
        Pemain.Tgl_Lahir,
        Pemain.Is_Captain,
        Pemain.Posisi,
        Pemain.NPM,
        Pemain.Jenjang
    FROM
        Pemain
    WHERE Nama_Tim='AS Roma';
    """)
    
    context = {"list_team": res}

    return render(request, "tim.html", context)
