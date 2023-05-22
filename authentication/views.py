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
    res = query(f"SELECT * FROM manajer WHERE USERNAME='{username}'")
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
            return redirect("/")


def login_view(request):
    if is_authenticated(request):
        return redirect("/")

    return render(request, "login.html")


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
            context = {'message': "Harap isi data dengan benar!",
                       'gagal': True}
            return render(request, 'register-manajer.html', context)
        else:
            a = query(f"INSERT INTO user_system VALUES ('{username}', '{password}')")
            print(a)
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
            context = {'message': "Harap isi data dengan benar!",
                       'gagal': True}
            return render(request, 'register-penonton.html',context)
        else:
            a = query(f"INSERT INTO user_system VALUES ('{username}', '{password}')")
            print(a)
            b = query(f"INSERT INTO non_pemain VALUES ('{id}', '{fname}', '{lname}', '{no_telp}', '{email}', '{alamat}')")
            print(b)
            c = query(f"INSERT INTO penonton VALUES ('{id}', '{username}')")
            print(c)
            for (stat) in status:
                d = query(f"INSERT INTO status_non_pemain VALUES ('{id}', '{stat}')")
            return redirect("/login")

@csrf_exempt
def register_panitia(request):
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
            context = {'message': "Harap isi data dengan benar!",
                       'gagal': True}
            return render(request, 'register-panitia.html', context)
        else:
            a = query(f"INSERT INTO user_system VALUES ('{username}', '{password}')")
            print(a)
            b = query(f"INSERT INTO non_pemain VALUES ('{id}', '{fname}', '{lname}', '{no_telp}', '{email}', '{alamat}')")
            print(b)
            c = query(f"INSERT INTO panitia VALUES ('{id}', '{jabatan} ,'{username}')")
            print(c)
            for (stat) in status:
                d = query(f"INSERT INTO status_non_pemain VALUES ('{id}', '{stat}')")
                print(d)
            return redirect("/login")