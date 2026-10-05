# Dokumen Kebutuhan Data - Koperasi Mahasiswa (Kopma Sejahtera)
*(Studi Kasus Terbimbing & Latihan Modul 2)*

**Identitas Mahasiswa:**
- **Nama:** Laelin Hidayaturrohma
- **NIM:** 25430074
- **Kelas:** C

---

## 1. Latar Belakang dan Aktivitas Organisasi
Koperasi Mahasiswa (Kopma) Sejahtera mengelola penjualan alat tulis kantor (ATK), makanan ringan, dan minuman. Penjualan dilakukan oleh kasir untuk pembeli umum maupun anggota mahasiswa. Sistem dirancang untuk mencatat transaksi penjualan, mengelola stok barang, mencatat pemesanan ke pemasok, serta mengelola poin loyalitas anggota.

---

## 2. Aktor dan Proses Bisnis (PB)

| Kode | Proses Bisnis | Aktor | Pemicu |
| :--- | :--- | :--- | :--- |
| **PB-01** | Mendaftarkan anggota baru | Kasir / Pengurus | Mahasiswa mendaftar |
| **PB-02** | Mencatat transaksi penjualan | Kasir | Pembeli membayar di kasir |
| **PB-03** | Memesan barang ke pemasok | Petugas Gudang | Stok berada di bawah batas minimum |
| **PB-04** | Menerima barang dari pemasok | Petugas Gudang | Barang datang beserta faktur |
| **PB-05** | Menyusun laporan bulanan | Ketua Koperasi | Awal bulan / periode laporan |
| **PB-06** | Penukaran poin loyalitas | Kasir | Anggota meminta penukaran poin |

---

## 3. Aturan Bisnis (AB)
- **AB-01:** Setiap nota penjualan memiliki nomor unik dan minimal berisi satu baris barang.
- **AB-02:** Penjualan dapat dilakukan tanpa anggota; jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%.
- **AB-03:** Stok barang tidak boleh bernilai negatif; transaksi penjualan ditolak jika jumlah beli melebihi stok.
- **AB-04:** Harga jual yang dicatat pada nota disimpan per transaksi dan tidak berubah meskipun harga barang di katalog naik.
- **AB-05:** NIM anggota bersifat unik; pencarian data anggota dapat dilakukan melalui nomor anggota atau NIM.
- **AB-06:** Pesanan pembelian dibuat otomatis/manual jika stok barang berada di bawah batas minimum.
- **AB-07:** Setiap kelipatan belanja Rp10.000, anggota aktif mendapatkan 1 poin loyalitas.
- **AB-08:** Poin loyalitas dapat diakumulasikan dan tidak memiliki masa kedaluwarsa selama status keanggotaan aktif.
- **AB-09:** Kelipatan 50 poin loyalitas dapat ditukarkan dengan potongan harga sebesar Rp5.000 pada transaksi berikutnya.

---

## 4. Kebutuhan Informasi (KI)
- **KI-01:** Laporan total omzet dan jumlah nota per hari dan per bulan.
- **KI-02:** Daftar 5 barang terlaris per bulan berdasarkan total kuantitas penjualan.
- **KI-03:** Daftar barang yang stoknya berada di bawah batas minimum (*reorder point*).
- **KI-04:** Daftar 10 anggota dengan total akumulasi belanja terbesar per bulan.
- **KI-05:** Laporan riwayat perolehan dan penukaran poin loyalitas per anggota.

---

## 5. Entitas Kandidat dan Elemen Data
1. `anggota`: `id_anggota`, `no_anggota`, `nim_anggota`, `nama_anggota`, `prodi_anggota`, `no_hp_anggota`, `status_anggota`, `poin_loyalitas`.
2. `petugas`: `id_petugas`, `kode_petugas`, `nama_petugas`, `peran_petugas`.
3. `barang`: `id_barang`, `kode_barang`, `nama_barang`, `kategori_barang`, `harga_jual_barang`, `stok_barang`, `stok_min_barang`.
4. `penjualan`: `id_penjualan`, `no_nota_penjualan`, `tgl_penjualan`, `id_petugas`, `id_anggota`, `bayar_penjualan`, `poin_diperoleh`, `poin_ditukar`.
5. `detail_penjualan`: `id_penjualan`, `id_barang`, `qty_detail_penjualan`, `harga_satuan_detail_penjualan`.
6. `pemasok`: `id_pemasok`, `nama_pemasok`, `telepon_pemasok`, `alamat_pemasok`.
7. `pembelian`: `id_pembelian`, `no_faktur_pembelian`, `tgl_pembelian`, `id_pemasok`, `status_pembelian`.
8. `detail_pembelian`: `id_pembelian`, `id_barang`, `qty_detail_pembelian`, `harga_beli_detail_pembelian`.

---

## 6. Matriks CRUD (Proses vs Entitas)

| Proses Bisnis | Anggota | Barang | Penjualan | Detail Penjualan | Pemasok | Pembelian | Detail Pembelian |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **PB-01: Daftar Anggota** | C, R | - | - | - | - | - | - |
| **PB-02: Catat Penjualan** | R, U | R, U | C, R | C | - | - | - |
| **PB-03: Pesan ke Pemasok** | - | R | - | - | R | C | C |
| **PB-04: Terima Barang** | - | U | - | - | R | U | R |
| **PB-05: Laporan Bulanan** | R | R | R | R | R | R | R |
| **PB-06: Penukaran Poin** | R, U | - | C, U | - | - | - | - |

---

## 7. Kamus Data Awal (Cuplikan Elemen Utama)

| Elemen Data | Tipe / Format | Deskripsi | Aturan Bisnis | Penanggung Jawab |
| :--- | :--- | :--- | :--- | :--- |
| `no_anggota` | CHAR(6) | Nomor kartu anggota | Unik, format A-XXXX | Ketua Koperasi |
| `nim_anggota` | CHAR(10) | NIM Mahasiswa | Unik, 10 digit (AB-05) | Ketua Koperasi |
| `no_hp_anggota` | VARCHAR(15) | Nomor kontak HP | Data pribadi, akses terbatas | Ketua Koperasi |
| `poin_loyalitas` | INT | Akumulasi poin aktif | Kelipatan Rp10rb = 1 poin (AB-07) | Kasir / System |
| `no_nota_penjualan` | CHAR(12) | Nomor transaksi nota | Unik, format PJ-YYMM-XXXX | Kasir |
| `harga_satuan_detail_penjualan` | DECIMAL(12,2) | Harga jual saat transaksi | Tersimpan permanen (AB-04) | Kasir |
| `stok_barang` | INT | Jumlah fisik barang | Bilangan bulat >= 0 (AB-03) | Petugas Gudang |

---

## 8. Kebutuhan Non-Fungsional Data
- **Volume:** Memproses rata-rata 150 nota transaksi per hari.
- **Retensi:** Data transaksi disimpan minimal selama 5 tahun untuk audit keuangan.
- **Privasi:** Nomor HP anggota bersifat pribadi dan hanya dapat diakses oleh Ketua Koperasi.

---

## 9. Perbaikan Pernyataan Kebutuhan Kabur (Latihan E.2)
1. **Pernyataan Awal:** *"Data anggota harus aman."*  
   - **Perbaikan (Dapat Diuji):** "Sistem wajib mengenkripsi kata sandi anggota menggunakan algoritma BCRYPT, menerapkan kontrol akses berbasis peran (RBAC), serta mengunci akun secara otomatis jika terjadi 3 kali kegagalan login berturut-turut."
2. **Pernyataan Awal:** *"Sistem harus cepat mencari barang."*  
   - **Perbaikan (Dapat Diuji):** "Sistem harus menampilkan hasil pencarian barang berdasarkan nama atau kode barang dengan waktu respon kurang dari 1,5 detik pada beban puncak 100 pengguna bersamaan."
3. **Pernyataan Awal:** *"Laporan stok harus akurat."*  
   - **Perbaikan (Dapat Diuji):** "Sistem wajib memperbarui jumlah stok barang secara otomatis (*real-time*) tepat setelah transaksi dikonfirmasi lunas, dengan toleransi selisih antara fisik dan sistem sebesar 0%."