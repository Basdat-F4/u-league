# Installation

Aplikasi ini dibuat menggunakan Django 4.2 yang support Python 3.8, 3.9, 3.10, dan 3.11.

1. Install python dengan versi yang sesuai bila belum.


2. Aktifkan python environtment dengan mengetik perintah berikut di terminal.

    Di Windows

    ```
    basdat-tk-env\Scripts\activate
    ```


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
