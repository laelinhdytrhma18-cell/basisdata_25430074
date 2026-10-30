-- ============================================================
-- Berkas: p07_kueri_kopma_25430074.sql
-- Studi Kasus: Koperasi Mahasiswa (Kopma Sejahtera)
-- Mahasiswa: Laelin Hidayaturrohma (NPM: 25430074) - Kelas: C
-- ============================================================

USE kopma_25430074;

-- 1. Kueri KI-01: Menampilkan rekap omzet harian dengan format tanggal
SELECT DATE_FORMAT(tgl_penjualan, '%Y-%m-%d') AS tanggal,
       COUNT(no_nota_penjualan) AS total_nota,
       SUM(bayar_penjualan) AS total_omzet
FROM penjualan
GROUP BY DATE_FORMAT(tgl_penjualan, '%Y-%m-%d');

-- 2. Kueri KI-03: Menampilkan barang yang stoknya di bawah batas minimum (reorder point)
SELECT nama_barang, kategori_barang, stok_barang, stok_min_barang,
       CONCAT('Segera pesan ', (stok_min_barang * 2 - stok_barang), ' unit') AS rekomendasi_pesan
FROM barang
WHERE stok_barang <= stok_min_barang;

-- 3. Kueri Anggota: Menggunakan fungsi string CONCAT dan UPPER
SELECT UPPER(nama_anggota) AS nama_kapital, 
       CONCAT('NPM: ', npm_anggota, ' | Status: ', status_anggota) AS info_akademik,
       poin_loyalitas
FROM anggota;

-- 4. Kueri Transaksi: Menggunakan IFNULL dan CASE WHEN untuk status poin
SELECT p.no_nota_penjualan, p.tgl_penjualan,
       IFNULL(a.nama_anggota, 'Pembeli Umum (Non-Member)') AS pembeli,
       p.bayar_penjualan,
       CASE 
           WHEN p.bayar_penjualan > 30000 THEN 'Transaksi Besar'
           ELSE 'Transaksi Reguler'
       END AS kategori_transaksi
FROM penjualan p
LEFT JOIN anggota a ON p.id_anggota = a.id_anggota;