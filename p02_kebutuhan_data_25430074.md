# Dokumen Analisis Kebutuhan Data - Toko Online (toko_74)

**Identitas Mahasiswa:**
- **Nama:** Laelin Hidayaturrohma
- **NPM:** 25430074
- **Kelas:** C
- **Studi Kasus Usaha:** Laelin Scrunchie & Hair Accessories (`toko_74`)
- **Skenario Parameter NPM (74):**
  - Maximum Item per Transaksi ($N_1$) = $(74 \pmod 5) + 1 = 5$ item
  - Diskon Member ($N_2$) = $(74 \pmod{10}) + 1 = 5\%$
  - Target Transaksi Harian ($N_3$) = $(74 \pmod{50}) + 10 = 34$ transaksi/hari

---

## 1. Profil Sistem
Sistem Informasi Toko Online *Laelin Scrunchie & Hair Accessories* (`toko_74`) dirancang untuk mengelola operasional penjualan produk aksesori rambut secara digital. Sistem ini mencakup pengelolaan katalog produk (scrunchie, jepit rambut, bando, ikat rambut), pendaftaran dan status keanggotaan pelanggan, pencatatan transaksi penjualan, pemotongan stok otomatis, hingga penyimpanan riwayat transaksi.

---

## 2. Proses Bisnis (PB)

### PB-01: Registrasi dan Keanggotaan Pelanggan
- Pelanggan mendaftarkan akun dengan mengisi data diri (nama lengkap, email, nomor HP, dan alamat pengiriman).
- Sistem memverifikasi akun dan menetapkan status Keanggotaan (Non-Member / Member).
- Pelanggan dengan status Member berhak mendapatkan potongan harga otomatis sebesar **5%** untuk setiap transaksi.

### PB-02: Pengelolaan Katalog Produk Aksesori
- Admin mengelola data produk aksesori rambut berdasarkan kategori (misal: Scrunchie Satin, Hair Clip Korea, Headband, Hair Tie).
- Admin menentukan harga satuan, jumlah stok awal, dan deskripsi produk.
- Setiap transaksi dibatasi maksimal **5 item produk** berbeda dalam satu kali pemesanan.

### PB-03: Transaksi Penjualan dan Pengurangan Stok
- Pelanggan memilih produk aksesori dan memasukkannya ke keranjang belanja.
- Sistem menghitung subtotal, menerapkan diskon Member sebesar 5% jika berlaku, dan menerbitkan total pembayaran.
- Setelah pembayaran dikonfirmasi, status pesanan berubah menjadi "Lunas" dan stok produk berkurang secara otomatis.
- Sistem dirancang untuk menangani beban operasional rata-rata **34 transaksi per hari**.

---

## 3. Aktor Bisnis (AB)

| Kode Aktor | Nama Aktor | Peran dan Hak Akses |
| :--- | :--- | :--- |
| **AB-01** | **Pelanggan** | Mendaftar akun, melihat katalog aksesori, melakukan pemesanan (maks 5 item/transaksi), dan membayar tagihan. |
| **AB-02** | **Admin Toko** | Mengelola data produk & kategori, mengonfirmasi status pembayaran, serta memperbarui status pengiriman. |
| **AB-03** | **Pemilik Toko (Owner)** | Mengakses laporan penjualan harian (target 34 transaksi/hari) dan statistik produk terlaris. |

---

## 4. Identifikasi Entitas dan Atribut

### 1. Entitas `pelanggan`
Menyimpan data identitas pembeli yang terdaftar di sistem.
- `id_pelanggan` (INT, Primary Key, Auto Increment)
- `nama_lengkap` (VARCHAR 100)
- `email` (VARCHAR 100, Unique)
- `no_hp` (VARCHAR 15)
- `alamat` (TEXT)
- `status_member` (ENUM: 'Member', 'Non-Member')

### 2. Entitas `kategori`
Menyimpan pengelompokan jenis aksesori rambut.
- `id_kategori` (INT, Primary Key, Auto Increment)
- `nama_kategori` (VARCHAR 50)

### 3. Entitas `produk`
Menyimpan detail item aksesori rambut yang dijual.
- `id_produk` (INT, Primary Key, Auto Increment)
- `id_kategori` (INT, Foreign Key -> `kategori.id_kategori`)
- `nama_produk` (VARCHAR 100)
- `harga` (DECIMAL 10,2)
- `stok` (INT)

### 4. Entitas `pesanan`
Menyimpan header data transaksi pembelian.
- `id_pesanan` (INT, Primary Key, Auto Increment)
- `id_pelanggan` (INT, Foreign Key -> `pelanggan.id_pelanggan`)
- `tanggal_pesanan` (DATETIME)
- `total_harga` (DECIMAL 10,2)
- `diskon` (DECIMAL 10,2) -- Potongan harga 5% khusus Member
- `total_bayar` (DECIMAL 10,2)
- `status_pesanan` (ENUM: 'Pending', 'Lunas', 'Dikirim', 'Selesai', 'Batal')

### 5. Entitas `detail_pesanan`
Menyimpan rincian item aksesori dalam satu transaksi (maksimal 5 item).
- `id_detail` (INT, Primary Key, Auto Increment)
- `id_pesanan` (INT, Foreign Key -> `pesanan.id_pesanan`)
- `id_produk` (INT, Foreign Key -> `produk.id_produk`)
- `jumlah` (INT)
- `subtotal` (DECIMAL 10,2)

---

## 5. Kamus Data & Matriks CRUD

### Matriks CRUD (Create, Read, Update, Delete)

| Proses Bisnis | Pelanggan | Kategori | Produk | Pesanan | Detail Pesanan |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **PB-01: Registrasi Pelanggan** | C, R, U | - | - | - | - |
| **PB-02: Kelola Katalog Aksesori** | - | C, R, U, D | C, R, U, D | - | - |
| **PB-03: Transaksi & Pembayaran** | R | R | R, U | C, R, U | C, R |