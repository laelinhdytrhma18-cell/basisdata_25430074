USE kopma_25430074;

INSERT IGNORE INTO anggota (id_anggota, no_anggota, npm_anggota, nama_anggota, status_anggota, poin_loyalitas) VALUES
(3, 'A-003', '25430003', 'Dewi Lestari', 'aktif', 15),
(4, 'A-004', '25430004', 'Rizky Pratama', 'nonaktif', 2);

INSERT IGNORE INTO barang (id_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
(4, 'Air Mineral 600ml', 'Minuman', 3500.00, 40, 6),
(5, 'Teh Botol Kotak', 'Minuman', 4500.00, 25, 5),
(6, 'Binder Note A5', 'Alat Tulis', 18000.00, 15, 3);

INSERT IGNORE INTO penjualan (id_penjualan, no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
(4, 'PJ-2609-0002', '2026-09-02 09:15:00', 1, 2, 20000.00),
(5, 'PJ-2609-0003', '2026-09-02 14:20:00', 1, 1, 30000.00),
(6, 'PJ-2609-0004', '2026-09-05 11:05:00', 2, 3, 25000.00),
(7, 'PJ-2609-0005', '2026-09-12 13:30:00', 1, 2, 35000.00),
(8, 'PJ-2610-0001', '2026-10-03 10:10:00', 1, 2, 25000.00),
(9, 'PJ-2610-0002', '2026-10-14 15:45:00', 3, 1, 30000.00),
(10, 'PJ-2611-0001', '2026-11-05 09:50:00', 1, 2, 40000.00);

INSERT IGNORE INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan) VALUES
(1, 1, 2, 4500.00),
(3, 3, 2, 5300.00),
(4, 2, 2, 6500.00),
(5, 3, 2, 5300.00),
(5, 4, 2, 3500.00),
(6, 6, 1, 18000.00),
(7, 5, 3, 4500.00),
(7, 1, 2, 4500.00),
(8, 2, 2, 6500.00),
(8, 4, 2, 3500.00),
(9, 6, 1, 18000.00),
(10, 3, 3, 5300.00),
(10, 5, 2, 4500.00);