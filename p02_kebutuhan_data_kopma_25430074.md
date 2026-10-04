# Dokumen Analisis Kebutuhan Data - Koperasi Mahasiswa (Kopma)
(Latihan dan Modifikasi Modul 2)

**Identitas Mahasiswa:**
- **Nama:** Laelin Hidayaturrohma
- **NPM:** 25430074
- **Kelas:** C

---

## 1. Modifikasi Fitur Poin Loyalitas Anggota

### A. Aturan Bisnis Baru (Tambahan)
- **AB-07:** Setiap transaksi belanja Anggota berhak mendapatkan 1 poin loyalitas untuk setiap kelipatan belanja Rp10.000.
- **AB-08:** Poin loyalitas dapat diakumulasikan dan tidak memiliki masa kedaluwarsa selama status keanggotaan aktif.
- **AB-09:** Anggota dapat menukarkan kelipatan 50 poin loyalitas dengan voucher potongan harga sebesar Rp5.000 pada transaksi berikutnya.

### B. Elemen Data Tambahan (Kamus Data Baru)
1. `poin_loyalitas` (INT) pada entitas `anggota`: Menyimpan jumlah akumulasi poin aktif milik anggota.
2. `poin_diperoleh` (INT) pada entitas `transaksi`: Mencatat poin yang didapat dari transaksi berjalan.
3. `poin_ditukar` (INT) pada entitas `transaksi`: Mencatat jumlah poin yang digunakan untuk potongan harga pada transaksi berjalan.

### C. Kebutuhan Informasi Baru
- **KI-06:** Laporan riwayat akumulasi dan penukaran poin loyalitas per anggota.

### D. Pembaruan Matriks CRUD Kopma
| Proses Bisnis | Anggota | Barang | Transaksi | Penukaran Poin |
| :--- | :---: | :---: | :---: | :---: |
| **Pendaftaran Anggota** | C, R | - | - | - |
| **Transaksi & Perhitungan Poin** | R, U | R, U | C, R | C |
| **Penukaran Poin Loyalitas** | R, U | - | U | C, R, U |

---

## 2. Perbaikan Pernyataan Kebutuhan Kabur (Non-Fungsional)

### A. Pernyataan (a): "Data anggota harus aman"
- **Perbaikan (Terukur):** "Sistem wajib mengenkripsi kata sandi anggota menggunakan algoritma BCRYPT, mengimplementasikan batasan hak akses (RBAC), serta menerapkan batas maksimal 3 kali salah login sebelum akun dikunci sementara selama 15 menit."

### B. Pernyataan (b): "Sistem harus cepat mencari barang"
- **Perbaikan (Terukur):** "Sistem harus dapat menampilkan hasil pencarian barang berdasarkan nama atau kata kunci kategori dengan *response time* maksimal 1,5 detik pada kondisi beban puncak hingga 100 pengguna simultan."

### C. Pernyataan (c): "Laporan stok harus akurat"
- **Perbaikan (Terukur):** "Sistem harus melakukan pembaruan (*real-time sync*) jumlah stok barang secara otomatis saat transaksi selesai disetujui, dengan persentase toleransi selisih antara data fisik di gudang dan data sistem maksimal 0% (100% cocok)."