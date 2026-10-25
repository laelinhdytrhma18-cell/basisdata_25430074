-- ============================================================
-- Berkas: p05_ddl_kopma_25430074.sql
-- Basis Data: kopma_25430074
-- Modul 5: Membangun Struktur dengan DDL dan Constraint
-- ============================================================

CREATE DATABASE IF NOT EXISTS kopma_25430074;
USE kopma_25430074;

-- 1. Hapus tabel berurutan dari anak ke induk (agar tidak error Foreign Key)[cite: 20]
DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- 2. Buat Tabel Master (Induk)[cite: 20]

CREATE TABLE petugas (
    id_petugas SMALLINT NOT NULL AUTO_INCREMENT,
    kode_petugas CHAR(3) NOT NULL,
    nama_petugas VARCHAR(100) NOT NULL,
    peran_petugas ENUM('kasir', 'gudang', 'ketua') NOT NULL,
    CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
    CONSTRAINT uq_petugas_kode UNIQUE (kode_petugas)
) ENGINE=InnoDB;

CREATE TABLE anggota (
    id_anggota INT NOT NULL AUTO_INCREMENT,
    no_anggota VARCHAR(10) NOT NULL,
    nim_anggota CHAR(10) NOT NULL,
    nama_anggota VARCHAR(100) NOT NULL,
    status_anggota ENUM('aktif', 'nonaktif') DEFAULT 'aktif',
    poin_loyalitas INT DEFAULT 0,
    CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
    CONSTRAINT uq_anggota_no UNIQUE (no_anggota),
    CONSTRAINT uq_anggota_nim UNIQUE (nim_anggota),
    CONSTRAINT ck_anggota_poin CHECK (poin_loyalitas >= 0)
) ENGINE=InnoDB;

CREATE TABLE barang (
    id_barang INT NOT NULL AUTO_INCREMENT,
    kode_barang VARCHAR(10) NOT NULL,
    nama_barang VARCHAR(100) NOT NULL,
    kategori_barang ENUM('ATK', 'makanan', 'minuman') NOT NULL,
    harga_jual_barang DECIMAL(12,2) NOT NULL,
    stok_barang INT NOT NULL DEFAULT 0,
    stok_min_barang INT NOT NULL DEFAULT 5,
    CONSTRAINT pk_barang PRIMARY KEY (id_barang),
    CONSTRAINT uq_barang_kode UNIQUE (kode_barang),
    CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0),
    CONSTRAINT ck_barang_stok CHECK (stok_barang >= 0),
    CONSTRAINT ck_barang_stok_min CHECK (stok_min_barang >= 0)
) ENGINE=InnoDB;

CREATE TABLE pemasok (
    id_pemasok INT NOT NULL AUTO_INCREMENT,
    nama_pemasok VARCHAR(100) NOT NULL,
    telepon_pemasok VARCHAR(15) NULL,
    alamat_pemasok TEXT NULL,
    CONSTRAINT pk_pemasok PRIMARY KEY (id_pemasok)
) ENGINE=InnoDB;

-- 3. Buat Tabel Transaksi & Pendukung (Anak)[cite: 20]

CREATE TABLE penjualan (
    id_penjualan INT NOT NULL AUTO_INCREMENT,
    no_nota_penjualan CHAR(12) NOT NULL,
    tgl_penjualan DATETIME NOT NULL,
    id_petugas SMALLINT NOT NULL,
    id_anggota INT NULL,
    bayar_penjualan DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_penjualan PRIMARY KEY (id_penjualan),
    CONSTRAINT uq_penjualan_nota UNIQUE (no_nota_penjualan),
    CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) REFERENCES petugas(id_petugas),
    CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota) REFERENCES anggota(id_anggota) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE detail_penjualan (
    id_penjualan INT NOT NULL,
    id_barang INT NOT NULL,
    qty_detail_penjualan SMALLINT NOT NULL,
    harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_detail_penjualan PRIMARY KEY (id_penjualan, id_barang),
    CONSTRAINT fk_detail_penjualan FOREIGN KEY (id_penjualan) REFERENCES penjualan(id_penjualan) ON DELETE CASCADE,
    CONSTRAINT fk_detail_penjualan_barang FOREIGN KEY (id_barang) REFERENCES barang(id_barang),
    CONSTRAINT ck_detail_penjualan_qty CHECK (qty_detail_penjualan > 0),
    CONSTRAINT ck_detail_penjualan_harga CHECK (harga_satuan_detail_penjualan >= 0)
) ENGINE=InnoDB;

CREATE TABLE pembelian (
    id_pembelian INT NOT NULL AUTO_INCREMENT,
    no_faktur_pembelian VARCHAR(20) NOT NULL,
    tgl_pembelian DATE NOT NULL,
    id_pemasok INT NOT NULL,
    status_pembelian ENUM('dipesan', 'diterima') DEFAULT 'dipesan',
    CONSTRAINT pk_pembelian PRIMARY KEY (id_pembelian),
    CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok) REFERENCES pemasok(id_pemasok)
) ENGINE=InnoDB;

CREATE TABLE detail_pembelian (
    id_pembelian INT NOT NULL,
    id_barang INT NOT NULL,
    qty_detail_pembelian SMALLINT NOT NULL,
    harga_beli_detail_pembelian DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_detail_pembelian PRIMARY KEY (id_pembelian, id_barang),
    CONSTRAINT fk_detail_pembelian FOREIGN KEY (id_pembelian) REFERENCES pembelian(id_pembelian) ON DELETE CASCADE,
    CONSTRAINT fk_detail_pembelian_barang FOREIGN KEY (id_barang) REFERENCES barang(id_barang),
    CONSTRAINT ck_detail_pembelian_qty CHECK (qty_detail_pembelian > 0),
    CONSTRAINT ck_detail_pembelian_harga CHECK (harga_beli_detail_pembelian >= 0)
) ENGINE=InnoDB;