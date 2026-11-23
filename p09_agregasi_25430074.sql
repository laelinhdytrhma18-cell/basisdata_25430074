-- ============================================================================
-- Modul 9: Milestone Proyek 9 - Aggregations dan GROUP BY (Database: toko_074)
-- Nama file: p09_agregasi_25430074.sql
-- ============================================================================

USE toko_074;

-- Aktifkan ONLY_FULL_GROUP_BY sesuai ketentuan modul
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');

-- Penambahan data pesanan berstatus 'Batal' (NOTA-2609-031) agar laporan
-- status pembayaran memiliki minimal 3 kelompok ('Lunas', 'Pending', 'Batal').
INSERT INTO pesanan (id_pesanan, no_nota_pesanan, id_pelanggan, tgl_pesanan, diskon_member, status_pembayaran)
VALUES (31, 'NOTA-2609-031', 1, '2026-09-25 14:30:00', 5.00, 'Batal');

INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail)
VALUES (31, 1, 1, 12000.00);

-- [KI-01] Rekap penjualan per kategori produk
-- Hasil yang diharapkan: 5 baris kategori (Bando Kain, Scrunchie Satin,
-- Scrunchie Organza, Kunciran Rajut, Jepit Rambut).
SELECT k.nama_kategori,
       COUNT(DISTINCT p.id_pesanan) AS jumlah_pesanan,
       SUM(dp.qty_detail_pesanan) AS total_item,
       SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail) AS total_penjualan
FROM kategori k
JOIN produk pr ON pr.id_kategori = k.id_kategori
JOIN detail_pesanan dp ON dp.id_produk = pr.id_produk
JOIN pesanan p ON p.id_pesanan = dp.id_pesanan
GROUP BY k.id_kategori, k.nama_kategori
ORDER BY total_penjualan DESC;

-- [KI-02] Rekap pesanan berdasarkan status pembayaran
-- Hasil yang diharapkan: 3 baris status (Lunas = 533000.00, Pending = 112000.00,
-- Batal = 12000.00).
SELECT p.status_pembayaran,
       COUNT(DISTINCT p.id_pesanan) AS jumlah_pesanan,
       SUM(dp.qty_detail_pesanan) AS total_item,
       SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail) AS total_nilai
FROM pesanan p
JOIN detail_pesanan dp ON dp.id_pesanan = p.id_pesanan
GROUP BY p.status_pembayaran
ORDER BY total_nilai DESC;

-- [KI-03] Performa produk dengan total item terjual >= 2 (menggunakan HAVING)
-- Hasil yang diharapkan: 5 baris produk dengan total_terjual >= 2.
SELECT pr.nama_produk,
       k.nama_kategori,
       COUNT(DISTINCT dp.id_pesanan) AS jumlah_nota,
       SUM(dp.qty_detail_pesanan) AS total_terjual,
       SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail) AS total_nilai
FROM produk pr
JOIN kategori k ON k.id_kategori = pr.id_kategori
JOIN detail_pesanan dp ON dp.id_produk = pr.id_produk
GROUP BY pr.id_produk, pr.nama_produk, k.nama_kategori
HAVING SUM(dp.qty_detail_pesanan) >= 2
ORDER BY total_terjual DESC, total_nilai DESC;

-- [KI-04] Rekap penjualan per kategori per bulan dengan WITH ROLLUP
-- Hasil yang diharapkan: 11 baris termasuk subtotal per kategori (bulan = NULL)
-- dan grand total (jumlah_pesanan = 31, total_penjualan = 657000.00).
SELECT k.nama_kategori,
       DATE_FORMAT(p.tgl_pesanan, '%Y-%m') AS bulan,
       COUNT(DISTINCT p.id_pesanan) AS jumlah_pesanan,
       SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail) AS total_penjualan
FROM kategori k
JOIN produk pr ON pr.id_kategori = k.id_kategori
JOIN detail_pesanan dp ON dp.id_produk = pr.id_produk
JOIN pesanan p ON p.id_pesanan = dp.id_pesanan
GROUP BY k.nama_kategori, DATE_FORMAT(p.tgl_pesanan, '%Y-%m') WITH ROLLUP;

-- [KI-05] Rekap total belanja per pelanggan
-- Hasil yang diharapkan: 5 baris pelanggan diurutkan dari total_belanja tertinggi
-- (Siti Rahma = 166000.00 s.d. Eko Prasetyo = 90000.00).
SELECT pl.id_pelanggan,
       pl.nama_pelanggan,
       COUNT(DISTINCT p.id_pesanan) AS jumlah_pesanan,
       SUM(dp.qty_detail_pesanan) AS total_item,
       SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail) AS total_belanja
FROM pelanggan pl
JOIN pesanan p ON p.id_pelanggan = pl.id_pelanggan
JOIN detail_pesanan dp ON dp.id_pesanan = p.id_pesanan
GROUP BY pl.id_pelanggan, pl.nama_pelanggan
ORDER BY total_belanja DESC;