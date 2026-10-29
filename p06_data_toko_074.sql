-- ============================================================
-- Berkas: p06_data_25430074.sql
-- Proyek: toko_074 (Laelin Scrunchie & Hair Accessories)
-- Pemilik: Laelin Hidayaturrohma - NPM 25430074 - Kelas: C
-- Modul 6: DML (Data Manipulation Language)
-- ============================================================

-- Gunakan database proyek yang benar
USE toko_074;

-- -----------------------------------------------------------------
-- A. PENGISIAN DATA MASTER (INDUK) - Minimal 5 Baris per Tabel
-- -----------------------------------------------------------------

-- 1. Tabel Kategori (5 Baris)
INSERT INTO kategori (id_kategori, nama_kategori, deskripsi_kategori) VALUES
(1, 'Scrunchie Satin', 'Karet rambut bahan satin lembut dan mewah'),
(2, 'Scrunchie Organza', 'Karet rambut bahan organza transparan estetik'),
(3, 'Jepit Rambut', 'Jepit rambut Korea mutiara dan akrilik'),
(4, 'Bando Kain', 'Bando kepala bahan kain motif dan polos'),
(5, 'Kunciran Rajut', 'Kunciran handmade rajutan benang wol lembut');

-- 2. Tabel Pelanggan (5 Baris)
INSERT INTO pelanggan (id_pelanggan, email_pelanggan, nama_pelanggan, no_hp_pelanggan, status_member) VALUES
(1, 'budi.santoso@gmail.com', 'Budi Santoso', '081234567890', 'Member'),
(2, 'siti.rahma@gmail.com', 'Siti Rahma', '089876543210', 'Member'),
(3, 'eko.prasetyo@gmail.com', 'Eko Prasetyo', '085611223344', 'Non-Member'),
(4, 'dewi.lestari@gmail.com', 'Dewi Lestari', '087855443322', 'Member'),
(5, 'ahmad.fauzi@gmail.com', 'Ahmad Fauzi', '081399887766', 'Non-Member');

-- 3. Tabel Produk (5 Baris)
INSERT INTO produk (id_produk, id_kategori, nama_produk, harga_produk, stok_produk) VALUES
(1, 1, 'Scrunchie Satin Silk Maroon', 12000.00, 45),
(2, 2, 'Scrunchie Organza Soft Pink', 15000.00, 30),
(3, 3, 'Jepit Rambut Mutiara Korea', 8000.00, 50),
(4, 4, 'Bando Kain Estetis', 18000.00, 25),
(5, 5, 'Kunciran Rambut Rajut', 10000.00, 40);


-- -----------------------------------------------------------------
-- B. PENGISIAN DATA TRANSAKSI UTAMA - Minimal 30 Baris (3 Tanggal Berbeda)
-- -----------------------------------------------------------------

-- Tanggal 1: 2026-09-22 (10 Pesanan)
INSERT INTO pesanan (id_pesanan, no_nota_pesanan, id_pelanggan, tgl_pesanan, diskon_member, status_pembayaran) VALUES
(1, 'NOTA-2609-001', 1, '2026-09-22 09:10:00', 5.00, 'Lunas'),
(2, 'NOTA-2609-002', 2, '2026-09-22 09:30:00', 5.00, 'Lunas'),
(3, 'NOTA-2609-003', 3, '2026-09-22 10:15:00', 5.00, 'Pending'),
(4, 'NOTA-2609-004', 4, '2026-09-22 11:00:00', 5.00, 'Lunas'),
(5, 'NOTA-2609-005', 5, '2026-09-22 13:20:00', 5.00, 'Lunas'),
(6, 'NOTA-2609-006', 1, '2026-09-22 14:00:00', 5.00, 'Lunas'),
(7, 'NOTA-2609-007', 2, '2026-09-22 15:10:00', 5.00, 'Pending'),
(8, 'NOTA-2609-008', 3, '2026-09-22 16:00:00', 5.00, 'Lunas'),
(9, 'NOTA-2609-009', 4, '2026-09-22 16:45:00', 5.00, 'Lunas'),
(10, 'NOTA-2609-010', 5, '2026-09-22 17:30:00', 5.00, 'Lunas');

-- Tanggal 2: 2026-09-23 (10 Pesanan)
INSERT INTO pesanan (id_pesanan, no_nota_pesanan, id_pelanggan, tgl_pesanan, diskon_member, status_pembayaran) VALUES
(11, 'NOTA-2609-011', 2, '2026-09-23 09:00:00', 5.00, 'Lunas'),
(12, 'NOTA-2609-012', 3, '2026-09-23 09:45:00', 5.00, 'Lunas'),
(13, 'NOTA-2609-013', 4, '2026-09-23 10:30:00', 5.00, 'Lunas'),
(14, 'NOTA-2609-014', 5, '2026-09-23 11:15:00', 5.00, 'Pending'),
(15, 'NOTA-2609-015', 1, '2026-09-23 13:00:00', 5.00, 'Lunas'),
(16, 'NOTA-2609-016', 3, '2026-09-23 14:10:00', 5.00, 'Lunas'),
(17, 'NOTA-2609-017', 2, '2026-09-23 15:00:00', 5.00, 'Lunas'),
(18, 'NOTA-2609-018', 4, '2026-09-23 15:50:00', 5.00, 'Pending'),
(19, 'NOTA-2609-019', 5, '2026-09-23 16:30:00', 5.00, 'Lunas'),
(20, 'NOTA-2609-020', 1, '2026-09-23 17:15:00', 5.00, 'Lunas');

-- Tanggal 3: 2026-09-24 (10 Pesanan)
INSERT INTO pesanan (id_pesanan, no_nota_pesanan, id_pelanggan, tgl_pesanan, diskon_member, status_pembayaran) VALUES
(21, 'NOTA-2609-021', 3, '2026-09-24 09:15:00', 5.00, 'Lunas'),
(22, 'NOTA-2609-022', 4, '2026-09-24 10:00:00', 5.00, 'Lunas'),
(23, 'NOTA-2609-023', 5, '2026-09-24 10:45:00', 5.00, 'Pending'),
(24, 'NOTA-2609-024', 1, '2026-09-24 11:30:00', 5.00, 'Lunas'),
(25, 'NOTA-2609-025', 2, '2026-09-24 13:10:00', 5.00, 'Lunas'),
(26, 'NOTA-2609-026', 4, '2026-09-24 14:00:00', 5.00, 'Lunas'),
(27, 'NOTA-2609-027', 3, '2026-09-24 14:50:00', 5.00, 'Lunas'),
(28, 'NOTA-2609-028', 5, '2026-09-24 15:30:00', 5.00, 'Pending'),
(29, 'NOTA-2609-029', 1, '2026-09-24 16:15:00', 5.00, 'Lunas'),
(30, 'NOTA-2609-030', 2, '2026-09-24 17:00:00', 5.00, 'Lunas');


-- -----------------------------------------------------------------
-- C. PENGISIAN DETAIL PESANAN & PEMBAYARAN
-- -----------------------------------------------------------------

-- Detail Pesanan (Mematuhi constraint qty <= 5)
INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail) VALUES
(1, 1, 2, 12000.00), (2, 2, 1, 15000.00), (3, 3, 2, 8000.00), (4, 4, 2, 18000.00), (5, 5, 1, 10000.00),
(6, 1, 1, 12000.00), (7, 2, 2, 15000.00), (8, 3, 1, 8000.00), (9, 4, 3, 18000.00), (10, 5, 2, 10000.00),
(11, 1, 3, 12000.00), (12, 2, 1, 15000.00), (13, 3, 2, 8000.00), (14, 4, 1, 18000.00), (15, 5, 2, 10000.00),
(16, 1, 1, 12000.00), (17, 2, 3, 15000.00), (18, 3, 2, 8000.00), (19, 4, 1, 18000.00), (20, 5, 2, 10000.00),
(21, 1, 2, 12000.00), (22, 2, 1, 15000.00), (23, 3, 2, 8000.00), (24, 4, 1, 18000.00), (25, 5, 3, 10000.00),
(26, 1, 2, 12000.00), (27, 2, 1, 15000.00), (28, 3, 2, 8000.00), (29, 4, 2, 18000.00), (30, 5, 1, 10000.00);

-- Data Pembayaran (Relasi 1-to-1 untuk beberapa pesanan lunas)
INSERT INTO pembayaran (id_pesanan, tgl_pembayaran, metode_pembayaran, bukti_pembayaran) VALUES
(1, '2026-09-22 09:12:00', 'QRIS', 'bukti_001.jpg'),
(2, '2026-09-22 09:32:00', 'Transfer', 'bukti_002.jpg'),
(4, '2026-09-22 11:02:00', 'Tunai', NULL),
(5, '2026-09-22 13:22:00', 'QRIS', 'bukti_005.jpg'),
(6, '2026-09-22 14:02:00', 'Transfer', 'bukti_006.jpg');