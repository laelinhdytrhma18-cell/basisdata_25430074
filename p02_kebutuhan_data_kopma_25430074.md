# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

## 1. Latar Belakang dan Aktivitas Organisasi
Koperasi Mahasiswa Sejahtera mengelola penjualan alat tulis, makanan ringan, dan minuman. Koperasi melayani anggota dan umum. Permasalahan utama yang dihadapi adalah pencatatan harga historis, stok bernilai minus, pencarian data anggota, serta perhitungan poin loyalitas.

## 2. Aktor dan Proses Bisnis
| Kode | Proses Bisnis | Aktor | Pemicu |
| :--- | :--- | :--- | :--- |
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| PB-06 | Mengelola data pemasok | Petugas gudang / Admin | Adanya pemasok baru atau perubahan data pemasok |

## 3. Dokumen Sumber yang Dianalisis
- Formulir Pendaftaran Anggota
- Nota Penjualan
- Buku Catatan Stok & Faktur Pemasok

## 4. Entitas Kandidat dan Elemen Data
- **Anggota**: nomor anggota, NIM, nama, program studi, nomor HP, status aktif, poin_loyalitas
- **Barang**: kode, nama, kategori, harga jual, stok, batas minimum stok
- **Penjualan**: nomor nota, tanggal-jam, kasir, anggota (opsional), bayar, poin_diperoleh
- **Detail penjualan**: nomor nota, barang, qty, harga saat transaksi
- **Petugas**: kode petugas, nama, peran (kasir/gudang/ketua)
- **Pemasok**: kode, nama, telepon, alamat
- **Pembelian**: nomor faktur, tanggal, pemasok, barang, qty, harga beli

## 5. Aturan Bisnis
- **AB-01**: Setiap nota memiliki nomor unik dan minimal satu baris barang.
- **AB-02**: Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%.
- **AB-03**: Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia.
- **AB-04**: Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik.
- **AB-05**: NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM.
- **AB-06**: Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut.
- **AB-07**: Anggota memperoleh 1 poin loyalitas setiap kelipatan Rp10.000 belanja.
- **AB-08**: Poin loyalitas sebanyak 50 poin dapat ditukarkan dengan potongan belanja sebesar Rp5.000.

## 6. Kebutuhan Informasi
| Kode | Kebutuhan Informasi | Data yang Diperlukan |
| :--- | :--- | :--- |
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |
| KI-05 | Laporan total poin loyalitas tiap anggota | Anggota, penjualan |

## 7. Matriks CRUD
| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| PB-01 Daftar anggota | C | | | | | |
| PB-02 Catat penjualan | R, U | R, U | C | C | | |
| PB-03 Pesan ke pemasok | | R | | | R | C |
| PB-04 Terima barang | | U | | | R | U |
| PB-05 Laporan bulanan | R | R | R | R | | R |
| PB-06 Mengelola data pemasok | | | | | C, R, U | |

## 8. Kamus Data Awal
| Elemen | Arti | Contoh | Aturan | Penanggung Jawab |
| :--- | :--- | :--- | :--- | :--- |
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 25430074 | Unik, 8-10 digit | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| poin_loyalitas | Jumlah poin belanja anggota | 150 | Bilangan bulat >= 0 | Ketua |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat >= 0 | Kasir |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat >= 0 (AB-03) | Petugas gudang |

## 9. Kebutuhan Non-Fungsional
- Perkiraan volume ±150 nota per hari.
- Data transaksi disimpan minimal 5 tahun.
- Nomor HP anggota bersifat pribadi dan hanya boleh diakses oleh Ketua Koperasi sesuai UU PDP.

## 10. Isu Kualitas Data yang Diantisipasi
- Perubahan harga master barang tidak boleh mengubah riwayat nilai total nota lama.
- Mencegah timbulnya nilai stok minus pada buku catatan akibat keterlambatan pembaruan data fisik.