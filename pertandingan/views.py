from django.shortcuts import render
from utils.query import query
from django.views.decorators.csrf import csrf_exempt
import json
from django.http import HttpResponse, HttpResponseNotAllowed, HttpResponseBadRequest, HttpResponseRedirect, JsonResponse
from django.urls import reverse
from datetime import datetime, timedelta


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

def list_pertandingan_baru(request):
    res = query(f"""SELECT DISTINCT ON (P.id_pertandingan) P.id_pertandingan, 
    STRING_AGG(tp.nama_tim, ' vs ') AS Nama_Tim,
    P.start_datetime,
    (
        SELECT t1.nama_tim AS nama_pemenang
        FROM tim_pertandingan t1
        WHERE t1.id_pertandingan = P.id_pertandingan
        ORDER BY t1.skor DESC
        LIMIT 1
    ) AS pemenang
        FROM PERTANDINGAN P
        JOIN TIM_PERTANDINGAN tp ON P.id_pertandingan = tp.id_pertandingan
        WHERE tp.nama_tim != (
        SELECT t2.nama_tim
        FROM TIM_PERTANDINGAN t2
        WHERE t2.id_pertandingan = P.id_pertandingan
        ORDER BY t2.skor DESC
        LIMIT 1
)
GROUP BY P.id_pertandingan, P.start_datetime;
""")

    
    context = {
        'pertandingans':res
    }

    return render(request, 'list-pertandingan.html', context)

def list_peristiwa(request):
    if (request.method == "POST"):
        data = json.loads(request.body)
        nama_tim = data.get('nama_tim')

        response = HttpResponseRedirect(reverse('pertandingan:list_peristiwa'))
        response['location'] = reverse('pertandingan:list_peristiwa')

        response.set_cookie("nama_tim", nama_tim)

        print(response)
        return response
    if (request.method == "GET"):
        print('masuk get')
        nama_tim = request.COOKIES.get('nama_tim')
        res = query(f"""
        select id_pertandingan, jenis, pemain.id_pemain, nama_depan, nama_tim 
        from peristiwa 
        inner join pemain 
        on peristiwa.id_pemain=pemain.id_pemain
         where nama_tim='{nama_tim}' order by id_pertandingan
        """)
        print(res)

        context = {
            'peristiwas':res
        }
        
        return render(request, 'peristiwa-tim.html', context)
    
    
