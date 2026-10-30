-- ============================================================
-- Berkas: p07_kueri_25430074.sql
-- Proyek: toko_074 (Laelin Scrunchie & Hair Accessories)
-- Pemilik: Laelin Hidayaturrohma - NPM 25430074 - Kelas: C
-- Modul 7: Milestone Proyek - Kueri SELECT, Filter, & Fungsi Skalar
-- ============================================================

USE toko_074;

-- -----------------------------------------------------------------
-- KI-01: Laporan Transaksi dan Rekapitulasi Harian
-- -----------------------------------------------------------------

-- Kueri 1
-- KI: KI-01 | Pertanyaan: Apa saja nota transaksi dengan status lunas? | Hasil: Daftar nota dan tanggal pesanan yang lunas.
SELECT no_nota_pesanan AS Nomor_Nota, tgl_pesanan AS Waktu, status_pembayaran AS Status
FROM pesanan
WHERE status_pembayaran = 'Lunas';

-- Kueri 2 (Menggunakan BETWEEN)
-- KI: KI-01 | Pertanyaan: Transaksi apa saja antara tanggal 22 dan 24 September 2026? | Hasil: Filter pesanan berdasarkan rentang waktu.
SELECT no_nota_pesanan, tgl_pesanan, status_pembayaran
FROM pesanan
WHERE tgl_pesanan BETWEEN '2026-09-22 00:00:00' AND '2026-09-24 23:59:59';

-- Kueri 3 (Menggunakan Fungsi Tanggal DATE_FORMAT)
-- KI: KI-01 | Pertanyaan: Tanggal berapa saja pesanan dibuat dengan format DD/MM/YYYY? | Hasil: Daftar tanggal terformat rapi.
SELECT DISTINCT DATE_FORMAT(tgl_pesanan, '%d/%m/%Y') AS tanggal_transaksi
FROM pesanan;


-- -----------------------------------------------------------------
-- KI-02: Katalog Produk Aksesori Rambut
-- -----------------------------------------------------------------

-- Kueri 4 (Menggunakan LIKE & Fungsi String UPPER)
-- KI: KI-02 | Pertanyaan: Produk apa saja yang memiliki kata 'Scrunchie' (ditampilkan kapital)? | Hasil: Nama produk huruf besar dan harganya.
SELECT UPPER(nama_produk) AS nama_produk_kapital, harga_produk, stok_produk
FROM produk
WHERE nama_produk LIKE '%Scrunchie%';

-- Kueri 5 (Menggunakan IN)
-- KI: KI-02 | Pertanyaan: Produk mana yang harga satuannya 8000, 10000, atau 18000? | Hasil: Daftar produk dengan harga spesifik tersebut.
SELECT nama_produk, harga_produk
FROM produk
WHERE harga_produk IN (8000.00, 10000.00, 18000.00);


-- -----------------------------------------------------------------
-- KI-03: Riwayat Pelanggan dan Status Member
-- -----------------------------------------------------------------

-- Kueri 6
-- KI: KI-03 | Pertanyaan: Siapa saja pelanggan yang terdaftar sebagai Member? | Hasil: Daftar nama dan email member aktif.
SELECT nama_pelanggan, email_pelanggan, status_member
FROM pelanggan
WHERE status_member = 'Member';

-- Kueri 7 (Menggunakan IS NULL)
-- KI: KI-03 | Pertanyaan: Pelanggan siapa yang belum melengkapi nomor HP? | Hasil: Data pelanggan yang nomor HP-nya kosong/NULL.
SELECT nama_pelanggan, email_pelanggan, no_hp_pelanggan
FROM pelanggan
WHERE no_hp_pelanggan IS NULL;


-- -----------------------------------------------------------------
-- KI-04: Analisis Sisa Stok Produk
-- -----------------------------------------------------------------

-- Kueri 8 (Menggunakan CASE WHEN)
-- KI: KI-04 | Pertanyaan: Bagaimana status ketersediaan masing-masing produk berdasarkan stok? | Hasil: Kategori status stok (Melimpah, Cukup, Menipis).
SELECT nama_produk, stok_produk,
       CASE 
           WHEN stok_produk > 35 THEN 'Stok Melimpah'
           WHEN stok_produk BETWEEN 20 AND 35 THEN 'Stok Cukup'
           ELSE 'Stok Menipis'
       END AS evaluasi_stok
FROM produk;


-- -----------------------------------------------------------------
-- KI-05: Metode dan Status Pembayaran Pesanan
-- -----------------------------------------------------------------

-- Kueri 9
-- KI: KI-05 | Pertanyaan: Metode pembayaran apa saja yang digunakan dalam pesanan? | Hasil: Daftar ID pesanan dan metode bayarnya.
SELECT id_pesanan, metode_pembayaran
FROM pembayaran;

-- Kueri 10 (Menggunakan IFNULL)
-- KI: KI-05 | Pertanyaan: Apa keterangan bukti transaksi untuk setiap pembayaran? | Hasil: Menampilkan file bukti atau teks pengganti jika belum ada lampiran.
SELECT id_pesanan, metode_pembayaran,
       IFNULL(bukti_pembayaran, 'Belum ada lampiran bukti') AS keterangan_bukti
FROM pembayaran;