# 🏧 Sistem Pembayaran ATM dengan Dart

Program sederhana untuk melakukan transaksi pembayaran menggunakan bahasa pemrograman **Dart**.

Program memiliki beberapa validasi, yaitu **PIN, pemblokiran akun setelah 3 kali kesalahan PIN, limit harian, dan saldo**. Program juga menyediakan beberapa skenario pengujian untuk memastikan setiap aturan berjalan dengan benar.

---

## 1. Problem Statement

Dalam melakukan transaksi pembayaran melalui ATM, sistem perlu memastikan bahwa transaksi dilakukan oleh pengguna yang memiliki PIN yang benar serta memenuhi batas saldo dan limit transaksi.

Masalah yang harus diselesaikan adalah bagaimana membuat sistem yang dapat:

* Memvalidasi PIN pengguna.
* Menghitung jumlah kesalahan PIN.
* Memblokir akun setelah 3 kali PIN salah.
* Memeriksa apakah transaksi melebihi limit.
* Memeriksa apakah saldo mencukupi.
* Mengurangi saldo setelah transaksi berhasil.
* Mengurangi sisa limit setelah transaksi berhasil.
* Memberikan informasi berhasil atau gagal kepada pengguna.

---

## 2. Actor

Actor dalam sistem adalah:

**Nasabah / Pengguna ATM**

Pengguna melakukan transaksi dengan memberikan:

* PIN
* Jumlah pembayaran

Sistem kemudian melakukan validasi dan menentukan apakah transaksi dapat dilakukan.

---

## 3. Input & Output

### Input

| Input            | Tipe Data | Keterangan                   |
| ---------------- | --------- | ---------------------------- |
| PIN              | `String`  | PIN yang dimasukkan pengguna |
| Total pembayaran | `int`     | Nominal transaksi            |

Contoh:

```text
PIN   : 945313
Total : Rp500.000
```

### Output

Program menghasilkan informasi transaksi.

Contoh transaksi berhasil:

```text
SUKSES: saldo Rp500000, sisa limit Rp1500000
```

Contoh PIN salah:

```text
Gagal: PIN salah (1/3)
```

Contoh akun diblokir:

```text
Gagal: PIN salah (3/3), akun diblokir
```

Contoh saldo tidak cukup:

```text
Gagal: saldo tidak cukup
```

Contoh limit terlewati:

```text
Gagal: melebihi limit harian
```

---

## 4. Functional Requirement

Sistem harus dapat:

1. Menyimpan PIN yang benar.
2. Menyimpan saldo pengguna.
3. Menyimpan sisa limit transaksi.
4. Menerima PIN dan nominal transaksi.
5. Memvalidasi PIN.
6. Menghitung jumlah kesalahan PIN.
7. Memblokir akun setelah 3 kali PIN salah.
8. Memeriksa limit transaksi.
9. Memeriksa kecukupan saldo.
10. Mengurangi saldo jika transaksi berhasil.
11. Mengurangi limit jika transaksi berhasil.
12. Menampilkan status transaksi.

---

## 5. Business Rules

| Kode      | Business Rule                                                                          |
| --------- | -------------------------------------------------------------------------------------- |
| **BR-01** | PIN yang benar adalah `945313`.                                                        |
| **BR-02** | Jika PIN salah sebanyak 3 kali, akun akan diblokir.                                    |
| **BR-03** | Transaksi ditolak jika nominal melebihi sisa limit harian.                             |
| **BR-04** | Transaksi ditolak jika saldo tidak mencukupi.                                          |
| **BR-05** | Jika transaksi berhasil, saldo dan sisa limit akan dikurangi sesuai nominal transaksi. |


---

## 6. Decomposition

Masalah utama dipecah menjadi beberapa bagian:

```text
Sistem Pembayaran ATM
│
├── Data
│   ├── PIN benar
│   ├── Saldo
│   ├── Sisa limit
│   ├── Jumlah PIN salah
│   └── Status blokir
│
├── Validasi PIN
│   ├── PIN benar
│   ├── PIN salah
│   └── Blokir setelah 3 kali salah
│
├── Validasi Transaksi
│   ├── Cek akun diblokir
│   ├── Cek limit
│   └── Cek saldo
│
├── Proses Pembayaran
│   ├── Kurangi saldo
│   └── Kurangi limit
│
└── Output
    ├── Transaksi berhasil
    └── Transaksi gagal
```

---

## 7. Pattern Recognition

Dari masalah tersebut ditemukan beberapa pola:

### Pola 1 — Validasi PIN

Setiap PIN yang dimasukkan selalu dibandingkan dengan PIN yang benar.

```text
Input PIN
   ↓
PIN benar?
 ┌─┴─┐
Ya  Tidak
↓     ↓
Reset  Tambah
error  error
```

### Pola 2 — Validasi Transaksi

Setiap transaksi harus melewati pemeriksaan yang sama:

```text
Akun diblokir?
      ↓
    Tidak
      ↓
Limit cukup?
      ↓
    Ya
      ↓
Saldo cukup?
      ↓
    Ya
      ↓
Transaksi berhasil
```

### Pola 3 — Perubahan Saldo dan Limit

Jika transaksi berhasil:

```text
saldo = saldo - total
limit = limit - total
```

Jika transaksi gagal, saldo dan limit tidak berubah.

---

## 8. Abstraction

Program menggunakan beberapa data utama untuk merepresentasikan kondisi ATM.

### Atribut / Variabel

```dart
const String pinBenar = '945313';

int saldo = 1000000;

int sisaLimit = 2000000;

int pinSalah = 0;

bool diblokir = false;
```

| Variabel    | Tipe     | Fungsi                          |
| ----------- | -------- | ------------------------------- |
| `pinBenar`  | `String` | Menyimpan PIN yang benar        |
| `saldo`     | `int`    | Menyimpan saldo pengguna        |
| `sisaLimit` | `int`    | Menyimpan sisa limit transaksi  |
| `pinSalah`  | `int`    | Menghitung jumlah kesalahan PIN |
| `diblokir`  | `bool`   | Menentukan apakah akun diblokir |

### Function

Program menggunakan beberapa function:

```dart
bool cekPin(String input)
```

Digunakan untuk memeriksa PIN.

```dart
bool limitTerlewati(int total)
```

Digunakan untuk memeriksa apakah transaksi melebihi limit.

```dart
bool saldoKurang(int total)
```

Digunakan untuk memeriksa apakah saldo tidak mencukupi.

```dart
String bayar(int total, String input)
```

Digunakan untuk menjalankan seluruh proses pembayaran.

---

## 9. Algorithm

Algoritma utama terdapat pada function `bayar()`.

1. Periksa apakah akun sudah diblokir.
2. Jika akun diblokir, transaksi langsung ditolak.
3. Periksa PIN menggunakan `cekPin()`.
4. Jika PIN salah:

   * Tambahkan jumlah kesalahan PIN.
   * Jika kesalahan mencapai 3, blokir akun.
   * Transaksi ditolak.
5. Jika PIN benar, lanjutkan proses.
6. Periksa apakah nominal transaksi melebihi sisa limit.
7. Jika melebihi limit, transaksi ditolak.
8. Periksa apakah saldo mencukupi.
9. Jika saldo tidak cukup, transaksi ditolak.
10. Jika semua validasi berhasil:

    * Kurangi saldo.
    * Kurangi sisa limit.
11. Tampilkan pesan transaksi berhasil.

### Logika Utama

```text
PIN benar
    ↓
Cek limit
    ↓
Cek saldo
    ↓
Kurangi saldo
    ↓
Kurangi limit
    ↓
Transaksi sukses
```

---

## 10. Flowchart untuk Proses Utama

```text
             ┌──────────────┐
             │    MULAI     │
             └──────┬───────┘
                    │
                    ▼
          ┌───────────────────┐
          │ Input PIN & total │
          └─────────┬─────────┘
                    │
                    ▼
             ┌─────────────┐
             │ Dibokir ?   │
             └──────┬──────┘
                Ya  │  Tidak
                │   │
                ▼   ▼
        ┌──────────┐  ┌─────────────┐
        │  GAGAL   │  │ Cek PIN     │
        │ Diblokir │  └──────┬──────┘
        └──────────┘         │
                             ▼
                       ┌─────────────┐
                       │ PIN benar?  │
                       └──────┬──────┘
                          Tidak│Ya
                         ┌─────┘
                         ▼       │
                 ┌────────────┐  │
                 │ pinSalah++ │  │
                 └──────┬─────┘  │
                        │        │
                        ▼        │
                 ┌────────────┐  │
                 │ pinSalah   │  │
                 │    >= 3?   │  │
                 └──────┬─────┘  │
                    Ya  │ Tidak  │
                    ▼   │       │
             ┌──────────┐       │
             │ Diblokir │       │
             └────┬─────┘       │
                  └──────┐      │
                         ▼      ▼
                       ┌──────────────┐
                       │ Cek Limit    │
                       └──────┬───────┘
                              │
                              ▼
                       ┌──────────────┐
                       │ Limit cukup? │
                       └──────┬───────┘
                         Tidak│   Ya
                         ┌────┘    │
                         ▼         ▼
                   ┌─────────┐ ┌──────────────┐
                   │  GAGAL  │ │ Cek Saldo    │
                   └─────────┘ └──────┬───────┘
                                      │
                                      ▼
                               ┌──────────────┐
                               │ Saldo cukup? │
                               └──────┬───────┘
                                 Tidak│   Ya
                                 ┌────┘    │
                                 ▼         ▼
                           ┌─────────┐ ┌──────────────┐
                           │  GAGAL  │ │ Kurangi      │
                           │         │ │ saldo & limit│
                           └─────────┘ └──────┬───────┘
                                              │
                                              ▼
                                      ┌─────────────┐
                                      │   SUKSES    │
                                      └──────┬──────┘
                                             │
                                             ▼
                                      ┌─────────────┐
                                      │   SELESAI   │
                                      └─────────────┘
```

---

## 11. Pseudocode

```text
START

SET pinBenar = "945313"
SET saldo = 1000000
SET sisaLimit = 2000000
SET pinSalah = 0
SET diblokir = false

FUNCTION cekPin(input)

    IF input == pinBenar THEN
        pinSalah = 0
        RETURN true
    END IF

    pinSalah = pinSalah + 1

    IF pinSalah >= 3 THEN
        diblokir = true
    END IF

    RETURN false

END FUNCTION


FUNCTION limitTerlewati(total)

    RETURN total > sisaLimit

END FUNCTION


FUNCTION saldoKurang(total)

    RETURN saldo < total

END FUNCTION


FUNCTION bayar(total, input)

    IF diblokir == true THEN
        RETURN "Gagal: akun diblokir"
    END IF

    IF cekPin(input) == false THEN

        IF diblokir == true THEN
            RETURN "Gagal: PIN salah (3/3), akun diblokir"
        END IF

        RETURN "Gagal: PIN salah"

    END IF

    IF limitTerlewati(total) == true THEN
        RETURN "Gagal: melebihi limit harian"
    END IF

    IF saldoKurang(total) == true THEN
        RETURN "Gagal: saldo tidak cukup"
    END IF

    saldo = saldo - total
    sisaLimit = sisaLimit - total

    RETURN "SUKSES"

END FUNCTION


TEST transaksi dengan berbagai PIN dan nominal

END
```

---

## 🧪 Test Scenario

Program memiliki 8 skenario pengujian:

| Skenario |       Total | PIN      | Hasil                                        |
| -------- | ----------: | -------- | -------------------------------------------- |
| 1        |   Rp500.000 | `945313` | Sukses                                       |
| 2        | Rp2.000.000 | `111111` | PIN salah                                    |
| 3        | Rp2.500.000 | `945313` | Melebihi limit                               |
| 4        | Rp1.500.000 | `945313` | Saldo tidak cukup / tergantung kondisi saldo |
| 5        | Rp1.500.000 | `112233` | PIN salah                                    |
| 6        | Rp1.500.000 | `112233` | PIN salah                                    |
| 7        | Rp1.500.000 | `112233` | Akun diblokir                                |
| 8        |    Rp10.000 | `945313` | Tidak diproses karena akun sudah diblokir    |

> **Catatan:** Skenario dijalankan secara berurutan, sehingga `saldo`, `sisaLimit`, `pinSalah`, dan `diblokir` berubah dari satu skenario ke skenario berikutnya.

---

## 👨‍💻 Author

**Adyl Pandu Setiawan**

Repository ini dibuat sebagai tugas pembelajaran pemrograman Dart.

---

## 📌 Kesimpulan

Program ini menerapkan konsep Computational Thinking melalui:

* **Decomposition** untuk memecah proses pembayaran menjadi beberapa validasi.
* **Pattern Recognition** untuk menemukan pola validasi PIN, saldo, dan limit.
* **Abstraction** melalui variabel dan function.
* **Algorithm** untuk menentukan urutan proses transaksi.
* **Flowchart** untuk menggambarkan proses utama.
* **Pseudocode** untuk menjelaskan algoritma sebelum implementasi ke Dart.
