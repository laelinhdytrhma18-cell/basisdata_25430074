-- ============================================================
-- Berkas: install_uts_25430074.sql
-- UTS Proyek Tahap 1 - Clean Install Script
-- Pengembang: Laelin Hidayaturrohma (NPM: 25430074 - Kelas: C)
-- Studi Kasus: Laelin Scrunchie & Hair Accessories (toko_074)
-- ============================================================

-- 1. Persiapan Basis Data & User Pengembang
CREATE DATABASE IF NOT EXISTS toko_074
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'dev_074'@'localhost' IDENTIFIED BY 'password_kerja';
GRANT ALL PRIVILEGES ON toko_074.* TO 'dev_074'@'localhost';
FLUSH PRIVILEGES;

USE toko_074;

-- 2. Hapus Tabel Berurutan (Pembersihan Lingkungan / Clean Reset)
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS detail_pesanan;
DROP TABLE IF EXISTS pesanan;
DROP TABLE IF EXISTS produk;
DROP TABLE IF EXISTS kategori;
DROP TABLE IF EXISTS pelanggan;

-- 3. Eksekusi Skema DDL & Constraint (p05)
CREATE TABLE kategori (
    id_kategori INT AUTO_INCREMENT,
    nama_kategori VARCHAR(100) NOT NULL,
    deskripsi_kategori VARCHAR(255) NULL,
    CONSTRAINT pk_kategori PRIMARY KEY (id_kategori),
    CONSTRAINT uq_kategori_nama UNIQUE (nama_kategori)
) ENGINE=InnoDB;

CREATE TABLE pelanggan (
    id_pelanggan INT AUTO_INCREMENT,
    email_pelanggan VARCHAR(100) NOT NULL,
    nama_pelanggan VARCHAR(100) NOT NULL,
    no_hp_pelanggan VARCHAR(15) NULL,
    status_member ENUM('Member', 'Non-Member') NOT NULL DEFAULT 'Non-Member',
    CONSTRAINT pk_pelanggan PRIMARY KEY (id_pelanggan),
    CONSTRAINT uq_pelanggan_email UNIQUE (email_pelanggan)
) ENGINE=InnoDB;

CREATE TABLE produk (
    id_produk INT AUTO_INCREMENT,
    id_kategori INT NOT NULL,
    nama_produk VARCHAR(100) NOT NULL,
    harga_produk DECIMAL(10,2) NOT NULL,
    stok_produk INT NOT NULL DEFAULT 0,
    CONSTRAINT pk_produk PRIMARY KEY (id_produk),
    CONSTRAINT uq_produk_nama UNIQUE (nama_produk),
    CONSTRAINT fk_produk_kategori FOREIGN KEY (id_kategori) REFERENCES kategori(id_kategori),
    CONSTRAINT ck_produk_harga CHECK (harga_produk >= 0),
    CONSTRAINT ck_produk_stok CHECK (stok_produk >= 0)
) ENGINE=InnoDB;

CREATE TABLE pesanan (
    id_pesanan INT AUTO_INCREMENT,
    no_nota_pesanan VARCHAR(20) NOT NULL,
    id_pelanggan INT NOT NULL,
    tgl_pesanan DATETIME NOT NULL,
    diskon_member DECIMAL(5,2) DEFAULT 5.00,
    status_pembayaran ENUM('Pending', 'Lunas', 'Batal') NOT NULL DEFAULT 'Pending',
    CONSTRAINT pk_pesanan PRIMARY KEY (id_pesanan),
    CONSTRAINT uq_pesanan_nota UNIQUE (no_nota_pesanan),
    CONSTRAINT fk_pesanan_pelanggan FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
) ENGINE=InnoDB;

CREATE TABLE detail_pesanan (
    id_pesanan INT NOT NULL,
    id_produk INT NOT NULL,
    qty_detail_pesanan SMALLINT NOT NULL,
    harga_satuan_detail DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_detail_pesanan PRIMARY KEY (id_pesanan, id_produk),
    CONSTRAINT fk_detail_pesanan FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan) ON DELETE CASCADE,
    CONSTRAINT fk_detail_produk FOREIGN KEY (id_produk) REFERENCES produk(id_produk),
    CONSTRAINT ck_detail_qty CHECK (qty_detail_pesanan > 0 AND qty_detail_pesanan <= 5),
    CONSTRAINT ck_detail_harga CHECK (harga_satuan_detail >= 0)
) ENGINE=InnoDB;

CREATE TABLE pembayaran (
    id_pembayaran INT AUTO_INCREMENT,
    id_pesanan INT NOT NULL,
    tgl_pembayaran DATETIME NOT NULL,
    metode_pembayaran ENUM('QRIS', 'Transfer', 'Tunai') NOT NULL,
    bukti_pembayaran VARCHAR(255) NULL,
    CONSTRAINT pk_pembayaran PRIMARY KEY (id_pembayaran),
    CONSTRAINT uq_pembayaran_pesanan UNIQUE (id_pesanan),
    CONSTRAINT fk_pembayaran_pesanan FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. Pengisian Data Sampel DML (p06)

-- Master Data
INSERT INTO kategori (id_kategori, nama_kategori, deskripsi_kategori) VALUES
(1, 'Scrunchie Satin', 'Karet rambut bahan satin lembut dan mewah'),
(2, 'Scrunchie Organza', 'Karet rambut bahan organza transparan estetik'),
(3, 'Jepit Rambut', 'Jepit rambut Korea mutiara dan akrilik'),
(4, 'Bando Kain', 'Bando kepala bahan kain motif dan polos'),
(5, 'Kunciran Rajut', 'Kunciran handmade rajutan benang wol lembut');

INSERT INTO pelanggan (id_pelanggan, email_pelanggan, nama_pelanggan, no_hp_pelanggan, status_member) VALUES
(1, 'budi.santoso@gmail.com', 'Budi Santoso', '081234567890', 'Member'),
(2, 'siti.rahma@gmail.com', 'Siti Rahma', '089876543210', 'Member'),
(3, 'eko.prasetyo@gmail.com', 'Eko Prasetyo', '085611223344', 'Non-Member'),
(4, 'dewi.lestari@gmail.com', 'Dewi Lestari', '087855443322', 'Member'),
(5, 'ahmad.fauzi@gmail.com', 'Ahmad Fauzi', '081399887766', 'Non-Member');

INSERT INTO produk (id_produk, id_kategori, nama_produk, harga_produk, stok_produk) VALUES
(1, 1, 'Scrunchie Satin Silk Maroon', 12000.00, 45),
(2, 2, 'Scrunchie Organza Soft Pink', 15000.00, 30),
(3, 3, 'Jepit Rambut Mutiara Korea', 8000.00, 50),
(4, 4, 'Bando Kain Estetis', 18000.00, 25),
(5, 5, 'Kunciran Rambut Rajut', 10000.00, 40);

-- Data Transaksi Penjualan (30 Pesanan)
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
(10, 'NOTA-2609-010', 5, '2026-09-22 17:30:00', 5.00, 'Lunas'),
(11, 'NOTA-2609-011', 2, '2026-09-23 09:00:00', 5.00, 'Lunas'),
(12, 'NOTA-2609-012', 3, '2026-09-23 09:45:00', 5.00, 'Lunas'),
(13, 'NOTA-2609-013', 4, '2026-09-23 10:30:00', 5.00, 'Lunas'),
(14, 'NOTA-2609-014', 5, '2026-09-23 11:15:00', 5.00, 'Pending'),
(15, 'NOTA-2609-015', 1, '2026-09-23 13:00:00', 5.00, 'Lunas'),
(16, 'NOTA-2609-016', 3, '2026-09-23 14:10:00', 5.00, 'Lunas'),
(17, 'NOTA-2609-017', 2, '2026-09-23 15:00:00', 5.00, 'Lunas'),
(18, 'NOTA-2609-018', 4, '2026-09-23 15:50:00', 5.00, 'Pending'),
(19, 'NOTA-2609-019', 5, '2026-09-23 16:30:00', 5.00, 'Lunas'),
(20, 'NOTA-2609-020', 1, '2026-09-23 17:15:00', 5.00, 'Lunas'),
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

INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail) VALUES
(1, 1, 2, 12000.00), (2, 2, 1, 15000.00), (3, 3, 2, 8000.00), (4, 4, 2, 18000.00), (5, 5, 1, 10000.00),
(6, 1, 1, 12000.00), (7, 2, 2, 15000.00), (8, 3, 1, 8000.00), (9, 4, 3, 18000.00), (10, 5, 2, 10000.00),
(11, 1, 3, 12000.00), (12, 2, 1, 15000.00), (13, 3, 2, 8000.00), (14, 4, 1, 18000.00), (15, 5, 2, 10000.00),
(16, 1, 1, 12000.00), (17, 2, 3, 15000.00), (18, 3, 2, 8000.00), (19, 4, 1, 18000.00), (20, 5, 2, 10000.00),
(21, 1, 2, 12000.00), (22, 2, 1, 15000.00), (23, 3, 2, 8000.00), (24, 4, 1, 18000.00), (25, 5, 3, 10000.00),
(26, 1, 2, 12000.00), (27, 2, 1, 15000.00), (28, 3, 2, 8000.00), (29, 4, 2, 18000.00), (30, 5, 1, 10000.00);

INSERT INTO pembayaran (id_pesanan, tgl_pembayaran, metode_pembayaran, bukti_pembayaran) VALUES
(1, '2026-09-22 09:12:00', 'QRIS', 'bukti_001.jpg'),
(2, '2026-09-22 09:32:00', 'Transfer', 'bukti_002.jpg'),
(4, '2026-09-22 11:02:00', 'Tunai', NULL),
(5, '2026-09-22 13:22:00', 'QRIS', 'bukti_005.jpg'),
(6, '2026-09-22 14:02:00', 'Transfer', 'bukti_006.jpg');

-- 5. Konfirmasi Instalasi Bersih
SHOW TABLES;