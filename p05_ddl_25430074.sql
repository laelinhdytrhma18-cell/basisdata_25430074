-- ============================================================
-- Berkas: p05_ddl_25430074.sql
-- Proyek: toko_74 (Laelin Scrunchie & Hair Accessories)
-- Pemilik: Laelin Hidayaturrohma - NPM 25430074
-- Modul 5: Membangun Struktur dengan DDL dan Constraint
-- ============================================================

-- Gunakan database proyek
CREATE DATABASE IF NOT EXISTS toko_74;
USE toko_74;

-- 1. Hapus tabel berurutan dari anak ke induk (agar tidak error Foreign Key)
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS detail_pesanan;
DROP TABLE IF EXISTS pesanan;
DROP TABLE IF EXISTS produk;
DROP TABLE IF EXISTS kategori;
DROP TABLE IF EXISTS pelanggan;

-- 2. Buat Tabel Master (Induk)

-- Tabel kategori
CREATE TABLE kategori (
    id_kategori INT AUTO_INCREMENT,
    nama_kategori VARCHAR(100) NOT NULL,
    deskripsi_kategori TEXT NULL,
    CONSTRAINT pk_kategori PRIMARY KEY (id_kategori),
    CONSTRAINT uq_kategori_nama UNIQUE (nama_kategori)
) ENGINE=InnoDB;

-- Tabel pelanggan (AB-05: identitas unik pelanggan)
CREATE TABLE pelanggan (
    id_pelanggan INT AUTO_INCREMENT,
    email_pelanggan VARCHAR(100) NOT NULL,
    nama_pelanggan VARCHAR(100) NOT NULL,
    no_hp_pelanggan VARCHAR(15) NULL,
    status_member ENUM('Member', 'Non-Member') NOT NULL DEFAULT 'Non-Member',
    CONSTRAINT pk_pelanggan PRIMARY KEY (id_pelanggan),
    CONSTRAINT uq_pelanggan_email UNIQUE (email_pelanggan)
) ENGINE=InnoDB;

-- Tabel produk (AB-03: harga & stok dilarang minus)
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

-- 3. Buat Tabel Transaksi & Pendukung (Anak)

-- Tabel pesanan (AB-01: nomor nota unik; AB-02: diskon member 5%)
CREATE TABLE pesanan (
    id_pesanan INT AUTO_INCREMENT,
    no_nota_pesanan VARCHAR(20) NOT NULL,
    id_pelanggan INT NOT NULL,
    tgl_pesanan DATETIME NOT NULL,
    diskon_member DECIMAL(5,2) DEFAULT 5.00, -- Parameter N2 = 5%
    status_pembayaran ENUM('Pending', 'Lunas', 'Batal') NOT NULL DEFAULT 'Pending',
    CONSTRAINT pk_pesanan PRIMARY KEY (id_pesanan),
    CONSTRAINT uq_pesanan_nota UNIQUE (no_nota_pesanan),
    CONSTRAINT fk_pesanan_pelanggan FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
) ENGINE=InnoDB;

-- Tabel detail_pesanan (AB-04: salinan harga historis; N1 = maksimal 5 item per baris)
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

-- Tabel pembayaran (Relasi 1 to 1 opsional dengan pesanan)
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