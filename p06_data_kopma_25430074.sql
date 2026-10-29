-- ============================================================
-- Berkas: p06_data_kopma_25430074.sql
-- Langkah Percobaan DML - Studi Kasus Kopma Sejahtera
-- Mahasiswa: Laelin Hidayaturrohma (NPM: 25430074) (Kelas: C)
-- ============================================================

USE kopma_25430074;

-- -----------------------------------------------------------------
-- 1. Pengisian Data Induk (Master Data)
-- -----------------------------------------------------------------
INSERT INTO petugas (nama_petugas, peran_petugas) VALUES
('Rina Anggraini', 'kasir'),
('Baskoro Jati', 'ketua'),
('Hendra Wijaya', 'gudang');

INSERT INTO anggota (no_anggota, npm_anggota, nama_anggota, status_anggota, poin_loyalitas) VALUES
('A-001', '25430001', 'Budi Santoso', 'aktif', 10),
('A-002', '25430002', 'Siti Rahma', 'aktif', 5),
('A-003', '25430003', 'Eko Prasetyo', 'nonaktif', 0);

INSERT INTO barang (nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
('Pulpen Gel 0.5', 'Alat Tulis', 4000.00, 50, 5),
('Buku Tulis 58', 'Alat Tulis', 6500.00, 30, 5),
('Roti Cokelat', 'Makanan', 5000.00, 20, 2);

INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
('CV Sumber ATK', '081234567890', 'Jl. Merdeka No. 10'),
('UD Segar Jaya', '089876543210', 'Jl. Ahmad Yani No. 5');

-- -----------------------------------------------------------------
-- 2. Pengisian Data Transaksi Utama & Detail Nota (Langkah D.2)
-- -----------------------------------------------------------------
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) 
VALUES ('PJ-2609-0142', '2026-09-24 10:00:00', 1, 1, 25000.00);

-- Menggunakan INSERT ... SELECT untuk menyalin harga master secara dinamis
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 3, harga_jual_barang 
FROM barang WHERE nama_barang = 'Pulpen Gel 0.5';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 2, harga_jual_barang 
FROM barang WHERE nama_barang = 'Buku Tulis 58';