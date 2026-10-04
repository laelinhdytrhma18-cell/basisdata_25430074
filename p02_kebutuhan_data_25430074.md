# Dokumen Analisis Kebutuhan Data - Toko Online (toko_74)

**Identitas Mahasiswa:**
- **Nama:** Laelin Hidayaturrohma
- **NIM:** 25430074
- **Kelas:** C
- **Studi Kasus Usaha:** Laelin Scrunchie & Hair Accessories (`toko_74`)
- **Skenario Parameter NIM (74):**
  - Maximum Item per Transaksi ($N_1$) = $(74 \bmod 5) + 1 = 5$ item
  - Diskon Member ($N_2$) = $(74 \bmod 10) + 1 = 5\%$
  - Target Transaksi Harian ($N_3$) = $(74 \bmod 50) + 10 = 34$ transaksi/hari

---

## 1. Profil Sistem
Sistem Informasi Toko Online *Laelin Scrunchie & Hair Accessories* (`toko_74`) dirancang untuk mengelola operasional penjualan produk aksesori rambut secara digital. Sistem ini mencakup pengelolaan katalog produk (scrunchie, jepit rambut, bando), pendaftaran keanggotaan pelanggan, pencatatan transaksi penjualan, pemotongan stok otomatis, pembayaran, hingga penyimpanan riwayat transaksi.

---

## 2. Proses Bisnis (PB) - Minimal 4 PB
1. **PB-01: Registrasi & Pendaftaran Keanggotaan Pelanggan**  
   Pelanggan mendaftarkan akun dengan mengisi data diri. Sistem menetapkan status Keanggotaan (Non-Member/Member). Pelanggan Member mendapatkan diskon otomatis **5%**.
2. **PB-02: Pengelolaan Katalog Aksesori Rambut**  
   Admin mengelola kategori, produk, harga satuan, dan pembaruan jumlah stok barang.
3. **PB-03: Pemesanan & Pembatasan Transaksi Penjualan**  
   Pelanggan memilih item produk dengan batasan maksimal **5 item produk** per transaksi ($N_1=5$). Sistem menghitung subtotal dan potongan harga.
4. **PB-04: Pembayaran & Konfirmasi Status Pesanan**  
   Pelanggan melakukan pembayaran melalui metode yang dipilih. Admin mengonfirmasi pembayaran dan status transaksi diperbarui menjadi 'Lunas'.
5. **PB-05: Pengelolaan Laporan Penjualan Harian**  
   Sistem merekapitulasi seluruh transaksi penjualan harian untuk mendukung target operasional **34 transaksi per hari** ($N_3=34$).

---

## 3. Aturan Bisnis (AB) - Minimal 8 AB
- **AB-01:** Setiap pelanggan harus mendaftarkan email yang unik dan valid untuk pembuatan akun.
- **AB-02:** Status Member hanya diberikan kepada pelanggan yang telah melakukan pengisian formulir pendaftaran member.
- **AB-03:** Potongan harga/diskon sebesar 5% ($N_2=5\%$) otomatis diterapkan pada total belanja pelanggan berstatus Member.
- **AB-04:** Jumlah item berbeda dalam satu transaksi penjualan dibatasi maksimal 5 item ($N_1=5$).
- **AB-05:** Setiap transaksi penjualan wajib menerbitkan nomor faktur/pesanan unik.
- **AB-06:** Stok produk akan otomatis berkurang secara *real-time* setelah pembayaran transaksi dikonfirmasi ('Lunas').
- **AB-07:** Pembayaran pesanan diberi batas waktu maksimal 1x24 jam; jika lewat, pesanan otomatis dibatalkan ('Batal').
- **AB-08:** Pemilik Toko (Owner) berhak mengakses seluruh laporan keuangan dan rekapitulasi transaksi harian.

---

## 4. Kebutuhan Informasi (KI) - Minimal 5 KI
1. **KI-01:** Laporan rekapitulasi penjualan harian (target rata-rata 34 transaksi/hari).
2. **KI-02:** Daftar produk terlaris (*best seller*) berdasarkan kategori aksesori rambut.
3. **KI-03:** Riwayat transaksi belanja per pelanggan beserta status diskon member 5%.
4. **KI-04:** Laporan sisa stok produk yang berada di bawah ambang batas minimum (*reorder point*).
5. **KI-05:** Laporan ringkasan metode pembayaran dan status pembayaran pesanan (Pending/Lunas/Batal).

---

## 5. Entitas Kandidat - Minimal 6 Entitas
1. `pelanggan`: Menyimpan identitas dan status keanggotaan pembeli.
2. `kategori`: Menyimpan pengelompokan jenis aksesori (Scrunchie, Hair Clip, Headband, dll).
3. `produk`: Menyimpan detail item aksesori, harga, dan stok.
4. `pesanan`: Menyimpan *header* data transaksi penjualan dan total bayar.
5. `detail_pesanan`: Menyimpan rincian item barang yang dibeli (maksimal 5 item).
6. `pembayaran`: Menyimpan bukti, metode, dan status verifikasi pembayaran.

---

## 6. Kamus Data Awal (20 Elemen) dengan Kolom Penanggung Jawab

| No | Nama Elemen Data | Tipe Data | Deskripsi | Entitas | Penanggung Jawab |
| :---: | :--- | :--- | :--- | :--- | :--- |
| 1 | `id_pelanggan` | INT (PK) | ID Unik Pelanggan | `pelanggan` | System Admin |
| 2 | `nama_lengkap` | VARCHAR(100) | Nama lengkap pelanggan | `pelanggan` | Pelanggan |
| 3 | `email` | VARCHAR(100) | Email unik pelanggan | `pelanggan` | Pelanggan |
| 4 | `no_hp` | VARCHAR(15) | Nomor kontak HP | `pelanggan` | Pelanggan |
| 5 | `alamat` | TEXT | Alamat pengiriman | `pelanggan` | Pelanggan |
| 6 | `status_member` | ENUM | Status ('Member','Non-Member') | `pelanggan` | Admin Toko |
| 7 | `id_kategori` | INT (PK) | ID Unik Kategori produk | `kategori` | Admin Toko |
| 8 | `nama_kategori` | VARCHAR(50) | Nama jenis aksesori | `kategori` | Admin Toko |
| 9 | `id_produk` | INT (PK) | ID Unik Produk | `produk` | Admin Toko |
| 10 | `nama_produk` | VARCHAR(100) | Nama item aksesori rambut | `produk` | Admin Toko |
| 11 | `harga` | DECIMAL(10,2)| Harga satuan produk | `produk` | Admin Toko |
| 12 | `stok` | INT | Jumlah stok ketersediaan | `produk` | Admin Toko |
| 13 | `id_pesanan` | INT (PK) | ID Unik Transaksi Pesanan | `pesanan` | Kasir / System |
| 14 | `tanggal_pesanan` | DATETIME | Waktu transaksi dibuat | `pesanan` | System |
| 15 | `total_harga` | DECIMAL(10,2)| Total harga sebelum diskon | `pesanan` | System |
| 16 | `diskon` | DECIMAL(10,2)| Potongan harga member (5%) | `pesanan` | System |
| 17 | `total_bayar` | DECIMAL(10,2)| Total pembayaran akhir | `pesanan` | System |
| 18 | `id_detail` | INT (PK) | ID Unik Detail Item | `detail_pesanan` | System |
| 19 | `jumlah` | INT | Jumlah item dibeli (maks 5) | `detail_pesanan` | Pelanggan |
| 20 | `id_pembayaran` | INT (PK) | ID Unik Bukti Bayar | `pembayaran` | Admin Keuangan |

---

## 7. Matriks CRUD (Create, Read, Update, Delete)

| Proses Bisnis | Pelanggan | Kategori | Produk | Pesanan | Detail Pesanan | Pembayaran |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **PB-01: Registrasi Member** | C, R, U | - | - | - | - | - |
| **PB-02: Kelola Katalog** | - | C, R, U, D | C, R, U, D | - | - | - |
| **PB-03: Pemesanan Aksesori** | R | R | R, U | C, R | C, R | - |
| **PB-04: Pembayaran Pesanan** | R | - | - | R, U | R | C, R, U |
| **PB-05: Laporan Penjualan** | R | R | R | R | R | R |

---

## 8. Kebutuhan Non-Fungsional & Identifikasi Data Pribadi

### A. Keamanan & Identifikasi Data Pribadi (PII)
- **Data Pribadi Teridentifikasi:** `nama_lengkap`, `email`, `no_hp`, dan `alamat`.
- **Aturan Akses Data Pribadi:**
  - **Pelanggan:** Hanya dapat melihat dan memperbarui data pribadi milik sendiri.
  - **Admin Toko:** Dapat melihat nama, no HP, dan alamat untuk keperluan pengiriman barang.
  - **Pihak Luar/Tamu:** Tidak memiliki hak akses sama sekali ke tabel `pelanggan`.

### B. Performa & Ketersediaan
- Sistem mampu menangani beban kerja rata-rata **34 transaksi per hari** ($N_3=34$) dengan *response time* pencarian barang kurang dari 2 detik.

---

## 9. Dokumen Sumber Fiktif & Pembedahan

### Contoh Dokumen Sumber: Struk / Nota Penjualan Fiktif
```text
============================================================
           LAELIN SCRUNCHIE & HAIR ACCESSORIES              
         Jl. Ahmad Yani No. 74, Metro, Lampung              
============================================================
No. Nota   : NOTA-20261004-074         Tanggal : 04/10/2026
Pelanggan  : Budi Santoso              Status  : Member (Diskon 5%)
------------------------------------------------------------
No  Nama Produk            Qty    Harga Satuan    Subtotal
------------------------------------------------------------
1.  Scrunchie Satin Pink    2     Rp 15.000       Rp 30.000
2.  Korean Hair Clip Gold   1     Rp 25.000       Rp 25.000
3.  Velvet Headband Maroon  1     Rp 35.000       Rp 35.000
------------------------------------------------------------
Total Item : 3 (Maksimal 5 Item per Transaksi)
Total Sebelum Diskon                      : Rp 90.000
Diskon Member (5%)                        : Rp  4.500
------------------------------------------------------------
TOTAL BAYAR                               : Rp 85.500
Status Pembayaran                         : LUNAS
============================================================