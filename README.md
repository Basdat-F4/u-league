# Installation

Aplikasi ini dibuat menggunakan Django 4.2 yang support Python 3.8, 3.9, 3.10, dan 3.11.

1. Install python dengan versi yang sesuai bila belum.


2. Aktifkan python environtment dengan mengetik perintah berikut di terminal.

    Di Windows (Powershell)

    ```
    basdat-tk-env\bin\activate.ps1
    ```

    note: kalo gabisa runserver coba `basdat-tk-env\Scripts\activate`

    Di Mac.

    ```
    source basdat-tk-env/bin/activate
    ```

3. Install dependencies project dengan menjalankan perintah berikut. Perintah ini akan menginstall django dan dependency lainnya.

    ```
    pip install -r requirements.txt
    ```

4. Tambahkan file `.env` di base directory. Isi db url. Contoh di file .env.example

4. Jalankan aplikasi dengan mengetik perintah berikut di terminal.

    ```
    python manage.py runserver
    ```


# Developing
Berikut adalah notes dalam developing.

## Menambahkan dependency baru
Notes ini diperuntukkan ketika anda ingin menambahkan dependency/library baru pada aplikasi.

Sebelum ingin menginstall dependency baru pada aplikasi, jangan lupa aktifkan environtment. Setelah menginstall dependency tersebut,  perbarui requirements.txt dengan menjalankan ini di terminal..

```
python -m pip freeze > requirements.txt
```

<hr>
<br>
<br>
<h1> <b>⚽ BASDAT F4: U-LEAGUE ⚽ </b></h1>
<h2> <b>Deskripsi 📑 </b> </h2>
U-League adalah liga sepak bola antar universitas dan memerlukan
sistem untuk merekam informasi dan aktivitas yang terjadi. Aplikasi ini hadir sebagai sistem tersebut.

<h2> <b> Role 🙍 </b> </h2>

1. Manajer 
2. Panitia
3. Penonton

<h2> <b> Anggota Kelompok: </b> </h2>
<ul>
<li>2106652000 - Alizha</li>
<li>2106750263 - Naufal Weise Widyatama</li>
<li>2106751902 - Alvin Widi Nugroho</li>
<li>2106751285 -	Azmi Rahmadisha</li?>
<li>2106650222 -	Rania Maharani Narendra</li>
</ul>