from django.shortcuts import render, redirect
from utils.query import query
from django.views.decorators.csrf import csrf_exempt
import uuid


# Create your views here.
def homepage(request):
    return render(request, "login-and-register.html")

def is_authenticated(request):
    try:
        request.session["username"]
        return True
    except:
        return False

def get_session_data(request):
    if not is_authenticated(request):
        return {}

    try:
        return {"username": request.session["username"], "role": request.session["role"]}
    except:
        return {}
    
def get_role(username):
    res = query(f"SELECT * FROM Manajer WHERE USERNAME='{username}'")
    if len(res) > 0:
        return 'manajer'
    res = query(f"SELECT * FROM panitia WHERE USERNAME ='{username }'")
    if len(res) > 0:
        return 'panitia'
    res = query(f"SELECT * FROM penonton WHERE USERNAME='{username }'")
    if len(res) > 0:
        return 'penonton'

@csrf_exempt
def login(request):
    next = request.GET.get("next")
    cont = {}

    if request.method != "POST":
        return login_view(request)
    
    username=''
    password=''

    if is_authenticated(request):
        username = str(request.session["username"])
        password = str(request.session["password"])
    else:
        username = str(request.POST["username"])
        password = str(request.POST["password"])

    if not username or not password :
        cont["berhasil"] = True
        return render(request, "login.html", cont)
    
    role = get_role(username)
    print(role)

    if role == "" or role == None:
        if username and password :
            cont["gagal"] = True
            return render(request, "login.html", cont)

        return login_view(request)
    else:
        request.session["username"] = username
        request.session["password"] = password
        request.session["role"] = role
        request.session.set_expiry(0)
        request.session.modified = True

        if next != None and next != "None":
            return redirect(next)
        else:
            # update later, if role = "blabla"
            print(request.session["username"])
            if (role == "manajer"):
                return redirect("/dashboard-manajer")
            elif (role == "penonton"):
                return redirect("/dashboard-penonton")
            elif (role == 'panitia'):
                return redirect("/dashboard-panitia")

def login_view(request):
    if is_authenticated(request):
        return redirect("/")

    return render(request, "login.html")

def register_view(request):
    if is_authenticated(request):
        return redirect("/")

    return render(request, "register.html")


def logout(request):
    next = request.GET.get("next")

    if not is_authenticated(request):
        return redirect("/")

    request.session.flush()
    request.session.clear_expired()

    if next != None and next != "None":
        return redirect(next)
    else:
        return redirect("/")

@csrf_exempt
def register_manajer(request):
    context = {'message': "Harap isi data dengan benar!",
                       'gagal': True}
    if request.method != "POST":
        return render(request, 'register-manajer.html')
    else:
        username = str(request.POST['username'])
        password = str(request.POST["password"])
        fname = str(request.POST['fname'])
        lname = str(request.POST['lname'])
        no_telp = str(request.POST["hp"])
        email = str(request.POST["email"])
        alamat = str(request.POST['alamat'])
        status = request.POST.getlist('status')
        id = uuid.uuid4()
        isValid = username and email and fname and lname and password and no_telp and status

        if not isValid:
            print('gagal')
            return render(request, 'register-manajer.html', context)
        else:
            a = query(f"INSERT INTO user_system VALUES ('{username}', '{password}')")
            print(a)
            if isinstance(a, Exception):
                context['message'] = str(a).partition('CONTEXT')[0]
                context["gagal"] = True
                return render(request, 'register-manajer.html', context)
            else:
                b = query(f"INSERT INTO non_pemain VALUES ('{id}', '{fname}', '{lname}', '{no_telp}', '{email}', '{alamat}')")
                print(b)
                c = query(f"INSERT INTO manajer VALUES ('{id}', '{username}')")
                print(c)
                for (stat) in status:
                    d = query(f"INSERT INTO status_non_pemain VALUES ('{id}', '{stat}')")
                    print(d)
                return redirect("/login")
        
@csrf_exempt
def register_penonton(request):
    context = {'message': "Harap isi data dengan benar!", 'gagal': True}
    if request.method != "POST":
        return render(request, 'register-penonton.html')
    else:
        username = str(request.POST['username'])
        password = str(request.POST["password"])
        fname = str(request.POST['fname'])
        lname = str(request.POST['lname'])
        no_telp = str(request.POST["hp"])
        email = str(request.POST["email"])
        alamat = str(request.POST['alamat'])
        status = request.POST.getlist('status')
        id = uuid.uuid4()
        isValid = username and email and fname and lname and password and no_telp and status

        if not isValid:
            print('gagal')
            return render(request, 'register-penonton.html',context)
        else:
            a = query(f"INSERT INTO user_system VALUES ('{username}', '{password}')")
            print(a)
            if isinstance(a, Exception):
                context['message'] = str(a).partition('CONTEXT')[0]
                context["gagal"] = True
                return render(request, 'register-penonton.html', context)
            else:
                b = query(f"INSERT INTO non_pemain VALUES ('{id}', '{fname}', '{lname}', '{no_telp}', '{email}', '{alamat}')")
                print(b)
                c = query(f"INSERT INTO penonton VALUES ('{id}', '{username}')")
                print(c)
                for (stat) in status:
                    d = query(f"INSERT INTO status_non_pemain VALUES ('{id}', '{stat}')")
                return redirect("/login")

@csrf_exempt
def register_panitia(request):
    context = {'message': "Harap isi data dengan benar!",
                       'gagal': True}
    if request.method != "POST":
        return render(request, 'register-panitia.html')
    else:
        username = str(request.POST['username'])
        password = str(request.POST["password"])
        fname = str(request.POST['fname'])
        lname = str(request.POST['lname'])
        no_telp = str(request.POST["hp"])
        email = str(request.POST["email"])
        alamat = str(request.POST['alamat'])
        status = request.POST.getlist('status')
        id = uuid.uuid4()
        jabatan = str(request.POST['jabatan'])
        isValid = username and email and fname and lname and password and no_telp and status and jabatan

        if not isValid:
            print('gagal')
            return render(request, 'register-panitia.html', context)
        else:
            a = query(f"INSERT INTO user_system VALUES ('{username}', '{password}')")
            print(a)
            
            if isinstance(a, Exception):
                context['message'] = str(a).partition('CONTEXT')[0]
                context["gagal"] = True
                return render(request, 'register-panitia.html', context)
            else: 
                b = query(f"INSERT INTO non_pemain VALUES ('{id}', '{fname}', '{lname}', '{no_telp}', '{email}', '{alamat}')")
                print(b)
                c = query(f"INSERT INTO panitia VALUES ('{id}', '{jabatan} ,'{username}')")
                print(c)
                for (stat) in status:
                    d = query(f"INSERT INTO status_non_pemain VALUES ('{id}', '{stat}')")
                    print(d)
                return redirect("/login")
        
def show_penonton_data(request):
    username = request.session["username"]
    id_penonton = query(f"SELECT id_penonton FROM PENONTON WHERE username = '{username}'")[0][0]
    res1 = query(f"""SELECT *
                    FROM NON_PEMAIN
                    WHERE id = '{id_penonton}';
                """)
    
    res2 = query(f""" SELECT status FROM STATUS_NON_PEMAIN WHERE id_non_pemain = '{id_penonton}';
                """)
    
    res3 = query(f"""
            SELECT DISTINCT ON (P.id_pertandingan) P.id_pertandingan, A.nama_tim as tim_a, B.nama_tim as tim_b, S.nama as stadium, concat(TO_CHAR(P.start_datetime::timestamp::date, ' DD Month YYYY'), ', ', TO_CHAR(start_datetime,'HH:MI'), ' - ', TO_CHAR(end_datetime,'HH:MI')) as display  
            FROM PERTANDINGAN P, TIM_PERTANDINGAN A, TIM_PERTANDINGAN B, STADIUM S, PEMBELIAN_TIKET PT
            WHERE P.id_pertandingan = A.id_pertandingan
            AND P.id_pertandingan = B.id_pertandingan
            AND S.id_stadium = P.stadium
            AND PT.id_pertandingan = P.id_pertandingan
            AND A.nama_tim != B.nama_tim
            AND PT.id_penonton = '{id_penonton}'
            GROUP BY P.id_pertandingan, A.nama_tim, B.nama_tim, S.nama;
            """)

    context = {'res1': res1[0], 'res2':res2, 'username': username, 'pertandingan': res3, 'noOrder': False}

    if (len(res3) < 1):
        context["pertandingan"] = "Belum Memesan Pertandingan"
        context["noOrder"] = True

    return render(request, "dashboard-penonton.html", context)

def show_manajer_data(request):
    username = request.session["username"]
    id_manajer = query(f"SELECT id_manajer FROM MANAJER WHERE username = '{username}'")[0][0]
    res1 = query(f"""SELECT *
                    FROM NON_PEMAIN
                    WHERE id = '{id_manajer}';
                """)
    
    res2 = query(f""" SELECT status FROM STATUS_NON_PEMAIN WHERE id_non_pemain = '{id_manajer}';
                """)
    
    res3 = query(f""" SELECT nama_tim
                    FROM TIM_MANAJER
                    WHERE id_manajer = '{id_manajer}'
                """)

    context = {'res1': res1[0], 'res2':res2, 'username': username, 'tim': res3, 'noTim': False}

    if (len(res3) < 1):
        context["tim"] = "Belum Membuat Tim"
        context["noTim"] = True

    return render(request, "dashboard-manajer.html", context)

def show_panitia_data(request):
    username = request.session["username"]
    id_panitia = query(f"SELECT id_panitia FROM PANITIA WHERE username = '{username}'")[0][0]
    res1 = query(f"""SELECT *
                    FROM NON_PEMAIN
                    WHERE id = '{id_panitia}';
                """)
    
    jabatan = query(f"SELECT jabatan FROM PANITIA WHERE username = '{username}'")[0][0]
    
    res2 = query(f""" SELECT status FROM STATUS_NON_PEMAIN WHERE id_non_pemain = '{id_panitia}';
                """)
    
    res3 = query(f"""
            SELECT DISTINCT ON (P.id_pertandingan) P.id_pertandingan, A.nama_tim as tim_a, B.nama_tim as tim_b, S.nama as stadium, concat(TO_CHAR(R.datetime::timestamp::date, ' DD Month YYYY'), ', ', TO_CHAR(R.datetime,'HH:MI')) as display, Concat(N.nama_depan, ' ', N.nama_belakang) as panitia, R.isi_rapat as isi  
            FROM PERTANDINGAN P, TIM_PERTANDINGAN A, TIM_PERTANDINGAN B, STADIUM S, RAPAT R, Non_Pemain N
            WHERE P.id_pertandingan = A.id_pertandingan
            AND P.id_pertandingan = B.id_pertandingan
            AND S.id_stadium = P.stadium
            AND R.id_pertandingan = P.id_pertandingan
            AND N.id = R.perwakilan_panitia
            AND A.nama_tim != B.nama_tim
            AND R.perwakilan_panitia = '{id_panitia}'
            GROUP BY P.id_pertandingan, A.nama_tim, B.nama_tim, S.nama, R.datetime, panitia, isi;
            """)

    context = {'res1': res1[0], 'res2':res2, 'username': username, 'rapat': res3, 'noRapat': False, 'jabatan': jabatan}

    if (len(res3) < 1):
        context["rapat"] = "Belum Ada Rapat"
        context["noRapat"] = True

    return render(request, "dashboard-panitia.html", context)
