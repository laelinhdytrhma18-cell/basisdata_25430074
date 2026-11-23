-- ============================================================================
-- Modul 9: Aggregations dan GROUP BY (Database: kopma_25430074)
-- Nama file: p09_agregasi_kopma_25430074.sql
-- ============================================================================

USE kopma_25430074;

-- [KI-1] Mengaktifkan mode ONLY_FULL_GROUP_BY dan mengecek ringkasan awal penjualan
-- Hasil yang diharapkan: @@sql_mode memuat ONLY_FULL_GROUP_BY; ringkasan menampilkan
-- jumlah nota = 9, awal = 2026-09-02 09:15:00, akhir = 2026-11-05 09:50:00.
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');
SELECT @@sql_mode;
SELECT COUNT(*) AS nota, MIN(tgl_penjualan) AS awal, MAX(tgl_penjualan) AS akhir
FROM penjualan;

-- [KI-2] Menghitung total nilai transaksi pada satu nota tertentu (PJ-2609-0001)
-- Hasil yang diharapkan: 1 baris untuk PJ-2609-0001 dengan jumlah = 10600.00.
SELECT p.no_nota_penjualan,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS jumlah
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.no_nota_penjualan = 'PJ-2609-0001'
GROUP BY p.id_penjualan, p.no_nota_penjualan;

-- [KI-3] Rekap omzet harian bulan September 2026 dengan COUNT(DISTINCT) dan WITH ROLLUP
-- Hasil yang diharapkan: 4 baris tanggal (2026-09-02 s.d. 2026-09-24) dan 1 baris
-- grand total (tanggal = NULL, nota = 6, omzet = 106700.00).
SELECT DATE(p.tgl_penjualan) AS tanggal,
       COUNT(DISTINCT p.id_penjualan) AS nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.tgl_penjualan >= '2026-09-01' AND p.tgl_penjualan < '2026-10-01'
GROUP BY DATE(p.tgl_penjualan) WITH ROLLUP;

-- [KI-4] Menyaring kelompok petugas yang melayani minimal 2 nota menggunakan HAVING
-- Hasil yang diharapkan: 1 baris petugas id_petugas = 1 (Rina Anggraini) dengan nota = 7.
SELECT pt.id_petugas, pt.nama_petugas, COUNT(DISTINCT p.id_penjualan) AS nota
FROM penjualan p
JOIN petugas pt ON pt.id_petugas = p.id_petugas
GROUP BY pt.id_petugas, pt.nama_petugas
HAVING COUNT(DISTINCT p.id_penjualan) >= 2;

-- [KI-5] Uji pelanggaran aturan ONLY_FULL_GROUP_BY (kolom non-agregat tidak di GROUP BY)
-- Hasil yang diharapkan: ERROR 1055 (42000) terkait pt.nama_petugas isn't in GROUP BY.
-- SELECT pt.id_petugas, pt.nama_petugas, COUNT(p.id_penjualan) AS nota
-- FROM penjualan p
-- JOIN petugas pt ON pt.id_petugas = p.id_penjualan
-- GROUP BY pt.id_petugas;

-- [KI-6] Perbandingan COUNT(*), COUNT(kolom), dan COUNT(DISTINCT ...) pada hasil JOIN
-- Hasil yang diharapkan: baris_join = 14, baris_detail_non_null = 14, jumlah_nota_unik = 9.
SELECT COUNT(*) AS baris_join,
       COUNT(d.id_barang) AS baris_detail_non_null,
       COUNT(DISTINCT p.id_penjualan) AS jumlah_nota_unik
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan;

-- [KI-7] Kombinasi filter baris (WHERE) dan filter kelompok (HAVING) pada anggota aktif
-- Hasil yang diharapkan: 2 baris anggota aktif dengan total_belanja >= 25000
-- (Budi Santoso = 71200.00 dan Siti Rahma = 80400.00).
SELECT a.id_anggota, a.nama_anggota,
       COUNT(DISTINCT p.id_penjualan) AS nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS total_belanja
FROM anggota a
JOIN penjualan p ON p.id_anggota = a.id_anggota
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE a.status_anggota = 'aktif'
GROUP BY a.id_anggota, a.nama_anggota
HAVING SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) >= 25000;

-- [Latihan & Modifikasi #1] Diskon 5% dan kembalian > 4000 untuk anggota aktif A-002
-- Hasil yang diharapkan: 4 baris nota milik A-002 (Siti Rahma) dengan kembalian > 4000.00
-- (7650.00, 13625.00, 6000.00, dan 16345.00).
SELECT p.no_nota_penjualan,
       a.no_anggota,
       a.nama_anggota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS subtotal,
       ROUND(SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) * 0.95, 2) AS total_diskon_5,
       MAX(p.bayar_penjualan) AS bayar_penjualan,
       ROUND(MAX(p.bayar_penjualan) - (SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) * 0.95), 2) AS kembalian
FROM penjualan p
JOIN anggota a ON a.id_anggota = p.id_anggota
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE a.no_anggota = 'A-002'
  AND a.status_anggota = 'aktif'
GROUP BY p.id_penjualan, p.no_nota_penjualan, a.no_anggota, a.nama_anggota
HAVING (MAX(p.bayar_penjualan) - (SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) * 0.95)) > 4000;

-- [Latihan & Modifikasi #2] Omzet per kategori barang per bulan dengan WITH ROLLUP
-- Hasil yang diharapkan: 11 baris rincian kategori & bulan, subtotal per kategori
-- (bulan = NULL), dan grand total (kategori_barang = NULL, bulan = NULL, nota = 9, omzet = 169600.00).
SELECT b.kategori_barang,
       DATE_FORMAT(p.tgl_penjualan, '%Y-%m') AS bulan,
       COUNT(DISTINCT p.id_penjualan) AS nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
FROM barang b
JOIN detail_penjualan d ON d.id_barang = b.id_barang
JOIN penjualan p ON p.id_penjualan = d.id_penjualan
GROUP BY b.kategori_barang, DATE_FORMAT(p.tgl_penjualan, '%Y-%m') WITH ROLLUP;