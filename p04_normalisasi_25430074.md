# p04: Normalisasi Proyek `toko_74` (Milestone Proyek 4)

**Identitas Mahasiswa**
- **Nama:** Laelin Hidayaturrohma
- **NIM:** 25430074
- **Kelas:** C
- **Studi Kasus:** Laelin Scrunchie & Hair Accessories (`toko_74`)
- **Berkas:** `p04_normalisasi_25430074.md`

---

## 1. Dokumen Sumber (Titik Awal UNF)

Dokumen sumber berasal dari p02: nota penjualan fiktif toko.

```text
============================================================
           LAELIN SCRUNCHIE & HAIR ACCESSORIES
         Jl. Ahmad Yani No. 74, Metro, Lampung
============================================================
No. Nota   : NOTA-20261004-074         Tanggal : 04/10/2026
Pelanggan  : Budi Santoso              Status  : Member (Diskon 5%)
------------------------------------------------------------
No  Nama Produk            Qty    Harga Satuan    Subtotal
------------------------------------------------------------
1.  Scrunchie Satin Pink    2     Rp 15.000       Rp 30.000
2.  Korean Hair Clip Gold   1     Rp 25.000       Rp 25.000
3.  Velvet Headband Maroon  1     Rp 35.000       Rp 35.000
------------------------------------------------------------
Total Item : 3 (Maksimal 5 Item per Transaksi)
Total Sebelum Diskon                      : Rp 90.000
Diskon Member (5%)                        : Rp  4.500
------------------------------------------------------------
TOTAL BAYAR                               : Rp 85.500
Status Pembayaran                         : LUNAS
============================================================
```

Nota memuat nomor, tanggal, pelanggan, status member, daftar produk, total, diskon, dan status pembayaran. Data pendukung dari p02 melengkapi UNF: email dan no HP pelanggan (PB-01), kategori dan stok produk (PB-02), serta metode dan bukti pembayaran (PB-04).

---

## 2. Tahapan Normalisasi

### A. Unnormalized Form (UNF)
Daftar produk dalam satu pesanan membentuk grup berulang (ditulis dalam `{ }`).

```
UNF_TOKO74 (no_nota_pesanan, tgl_pesanan, email_pelanggan, nama_pelanggan,
            no_hp_pelanggan, status_member,
            { nama_kategori, deskripsi_kategori, nama_produk, harga_produk, stok_produk,
              qty_detail_pesanan, harga_satuan_detail, subtotal_detail },
            total_sebelum_diskon, diskon_member, total_bayar,
            status_pembayaran, metode_pembayaran, tgl_pembayaran, bukti_pembayaran)
```

### B. First Normal Form (1NF)
Aku menghapus grup berulang sehingga setiap pesanan memiliki satu baris untuk setiap produk. Kunci primernya gabungan `(no_nota_pesanan, nama_produk)`.

```
1NF_TOKO74 (no_nota_pesanan, nama_produk, tgl_pesanan, email_pelanggan, nama_pelanggan,
            no_hp_pelanggan, status_member, nama_kategori, deskripsi_kategori,
            harga_produk, stok_produk, qty_detail_pesanan, harga_satuan_detail,
            subtotal_detail, total_sebelum_diskon, diskon_member, total_bayar,
            status_pembayaran, metode_pembayaran, tgl_pembayaran, bukti_pembayaran)
```

Nota di atas menjadi tiga baris:

| no_nota_pesanan | nama_produk | qty_detail_pesanan | harga_satuan_detail |
| :--- | :--- | :---: | ---: |
| NOTA-20261004-074 | Scrunchie Satin Pink | 2 | 15000 |
| NOTA-20261004-074 | Korean Hair Clip Gold | 1 | 25000 |
| NOTA-20261004-074 | Velvet Headband Maroon | 1 | 35000 |

Data pelanggan dan pesanan ikut berulang di ketiga baris. 2NF dan 3NF menghilangkan pengulangan itu.

---

## 3. Dependensi Fungsional (FD) Berbasis Aturan Bisnis

| FD | Dependensi | Dasar |
| :--- | :--- | :--- |
| FD-01 | `no_nota_pesanan` -> `tgl_pesanan`, `email_pelanggan`, `diskon_member`, `status_pembayaran` | AB-05: nomor pesanan unik. AB-03: diskon member 5% tersimpan per pesanan. AB-06 dan AB-07: status berubah menjadi Lunas atau Batal. |
| FD-02 | `no_nota_pesanan` -> `metode_pembayaran`, `tgl_pembayaran`, `bukti_pembayaran` | PB-04: satu pesanan memiliki satu pembayaran |
| FD-03 | `email_pelanggan` -> `nama_pelanggan`, `no_hp_pelanggan`, `status_member` | AB-01: email pelanggan unik. AB-02: status member melekat pada pelanggan. |
| FD-04 | `nama_produk` -> `nama_kategori`, `harga_produk`, `stok_produk` | PB-02: katalog produk. Nama produk unik di katalog. |
| FD-05 | `nama_kategori` -> `deskripsi_kategori` | PB-02: kategori memiliki deskripsi sendiri |
| FD-06 | `(no_nota_pesanan, nama_produk)` -> `qty_detail_pesanan`, `harga_satuan_detail` | AB-09 (usulan tambahan untuk p02): harga di nota tetap meski harga katalog berubah. AB-04: maksimal 5 produk per pesanan. |
| FD-07 | `qty_detail_pesanan`, `harga_satuan_detail` -> `subtotal_detail`; semua subtotal -> `total_sebelum_diskon`; `total_sebelum_diskon`, `diskon_member` -> `total_bayar` | Nilai turunan (AB-03) |

Catatan tentang FD-01: `diskon_member` ditentukan oleh pesanan, bukan oleh `status_member` yang berlaku sekarang. Seorang pelanggan bisa berganti status setelah pesanan terbit, tetapi nota lama harus menunjukkan diskon yang berlaku saat itu. Cara kerjanya sama dengan harga pada FD-06.

Catatan tentang FD-06: `nama_produk` saja tidak menentukan `harga_satuan_detail`. Harga katalog bisa naik setelah pesanan terbit, sedangkan nota lama harus menampilkan harga saat transaksi.

AB-04 membatasi jumlah baris produk per pesanan. Nota contoh memuat "Total Item: 3", yaitu tiga baris. Aku menegakkan batas ini di tahap implementasi (Pertemuan 5), bukan lewat normalisasi.

---

## 4. Keputusan Nilai Turunan

| Atribut | Rumus | Keputusan | Contoh nota |
| :--- | :--- | :--- | ---: |
| `subtotal_detail` | `qty_detail_pesanan` x `harga_satuan_detail` | Dihitung | 30.000 / 25.000 / 35.000 |
| `total_sebelum_diskon` | jumlah semua subtotal | Dihitung | 90.000 |
| nilai diskon | `total_sebelum_diskon` x `diskon_member` / 100 | Dihitung | 4.500 |
| `total_bayar` | `total_sebelum_diskon` - nilai diskon | Dihitung | 85.500 |
| `diskon_member` (persen) | persentase yang berlaku saat pesanan | **Disimpan** | 5,00 |
| `harga_satuan_detail` | harga yang berlaku saat pesanan | **Disimpan** | 15.000 dan seterusnya |

**Alasan menghitung.** Pesanan berstatus Pending bisa berubah selama batas 1x24 jam (AB-07): pelanggan menambah atau mengganti produk. Kolom `total_bayar` yang tersimpan menyimpang dari rincian setelah perubahan itu (anomali ubah). Aku menghapus `total_bayar` dari tabel `pesanan` dan menghitungnya lewat view:

```sql
CREATE VIEW v_total_pesanan AS
SELECT p.id_pesanan, p.no_nota_pesanan,
       SUM(d.qty_detail_pesanan * d.harga_satuan_detail) AS total_sebelum_diskon,
       ROUND(SUM(d.qty_detail_pesanan * d.harga_satuan_detail) * p.diskon_member / 100, 2) AS nilai_diskon,
       ROUND(SUM(d.qty_detail_pesanan * d.harga_satuan_detail) * (1 - p.diskon_member / 100), 2) AS total_bayar
FROM pesanan p
JOIN detail_pesanan d ON d.id_pesanan = p.id_pesanan
GROUP BY p.id_pesanan, p.no_nota_pesanan, p.diskon_member;
```

Pada data nota di atas view menghasilkan 90.000, 4.500, dan 85.500, sama dengan nota.

**Alasan menyimpan.** `diskon_member` dan `harga_satuan_detail` adalah fakta saat transaksi. Keduanya tidak bisa dihitung ulang dari data yang sekarang, karena status member dan harga katalog bisa berubah. Menghitung ulang riwayat dari data terbaru mengubah laporan masa lalu.

**Laporan arsip.** Untuk rekap harian (PB-05, KI-01) yang sudah ditutup, tabel arsip boleh menyimpan total sebagai potret. Keputusan itu menjadi bahasan tabel laporan, bukan tabel operasional ini.

---

## 5. Second Normal Form (2NF)

Kunci gabungan `(no_nota_pesanan, nama_produk)` mengharuskan pemeriksaan ketergantungan parsial:

- FD-01, FD-02, FD-03: atribut pesanan, pelanggan, dan pembayaran hanya bergantung pada `no_nota_pesanan`. Atribut itu pindah ke tabel `PESANAN`.
- FD-04: atribut produk dan kategori hanya bergantung pada `nama_produk`. Atribut itu pindah ke tabel `PRODUK`.
- FD-06: `qty_detail_pesanan` dan `harga_satuan_detail` bergantung pada seluruh kunci, sehingga tetap di `DETAIL_PESANAN`.

```
PESANAN_2NF (no_nota_pesanan, tgl_pesanan, email_pelanggan, nama_pelanggan, no_hp_pelanggan,
             status_member, diskon_member, status_pembayaran,
             metode_pembayaran, tgl_pembayaran, bukti_pembayaran)
PRODUK_2NF (nama_produk, nama_kategori, deskripsi_kategori, harga_produk, stok_produk)
DETAIL_PESANAN_2NF (no_nota_pesanan*, nama_produk*, qty_detail_pesanan, harga_satuan_detail)
```

---

## 6. Third Normal Form (3NF)

Dua rantai transitif tersisa:

- `no_nota_pesanan` -> `email_pelanggan` -> `nama_pelanggan`, `no_hp_pelanggan`, `status_member` (FD-01 dan FD-03). Aku memindahkan data pelanggan ke tabel `PELANGGAN`.
- `nama_produk` -> `nama_kategori` -> `deskripsi_kategori` (FD-04 dan FD-05). Aku memindahkan kategori ke tabel `KATEGORI`.

Data pembayaran (FD-02) bergantung langsung pada `no_nota_pesanan`, sehingga tidak melanggar 3NF. Aku memisahkannya sebagai keputusan desain: PB-04 memiliki aktor sendiri (Admin Keuangan), dan kolomnya kosong selama pesanan masih Pending. Relasinya tetap 1:1.

```
PELANGGAN (email_pelanggan, nama_pelanggan, no_hp_pelanggan, status_member)
KATEGORI (nama_kategori, deskripsi_kategori)
PRODUK (nama_produk, nama_kategori*, harga_produk, stok_produk)
PESANAN (no_nota_pesanan, email_pelanggan*, tgl_pesanan, diskon_member, status_pembayaran)
DETAIL_PESANAN (no_nota_pesanan*, nama_produk*, qty_detail_pesanan, harga_satuan_detail)
PEMBAYARAN (no_nota_pesanan*, metode_pembayaran, tgl_pembayaran, bukti_pembayaran)
-- kunci primer ditulis paling kiri (DETAIL_PESANAN: dua kolom pertama), * = kunci tamu
```

### Ringkasan tahapan

| Tahap | Masalah yang ditemukan | Tindakan | Hasil |
| :--- | :--- | :--- | :--- |
| UNF | Grup produk berulang dalam satu nota | - | `UNF_TOKO74` |
| 1NF | Satu nota berisi daftar produk | Satu baris per produk, kunci `(no_nota_pesanan, nama_produk)` | `1NF_TOKO74` |
| 2NF | Data pesanan dan produk bergantung pada sebagian kunci | Pisah `PESANAN` dan `PRODUK` | 3 tabel |
| 3NF | Data pelanggan dan deskripsi kategori bergantung lewat kolom non-kunci | Pisah `PELANGGAN` dan `KATEGORI`, lalu `PEMBAYARAN` sebagai keputusan desain | 6 tabel |

---

## 7. Skema Relasional Final dan Pemeriksaan BCNF

Aku mengganti kunci alami dengan kunci pengganti `id_*`. Kunci alami yang tersisa menjadi kunci unik.

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
| :--- | :--- | :--- | :--- |
| `kategori` | `id_kategori` | `nama_kategori` | - |
| `pelanggan` | `id_pelanggan` | `email_pelanggan` | - |
| `produk` | `id_produk` | `nama_produk` | `id_kategori` |
| `pesanan` | `id_pesanan` | `no_nota_pesanan` | `id_pelanggan` |
| `detail_pesanan` | (`id_pesanan`, `id_produk`) | - | `id_pesanan`, `id_produk` |
| `pembayaran` | `id_pembayaran` | `id_pesanan` | `id_pesanan` |

Atribut final setiap tabel:

1. `kategori` (**id_kategori**, nama_kategori, deskripsi_kategori)
2. `pelanggan` (**id_pelanggan**, email_pelanggan, nama_pelanggan, no_hp_pelanggan, status_member)
3. `produk` (**id_produk**, id_kategori, nama_produk, harga_produk, stok_produk)
4. `pesanan` (**id_pesanan**, no_nota_pesanan, id_pelanggan, tgl_pesanan, diskon_member, status_pembayaran)
5. `detail_pesanan` (**id_pesanan**, **id_produk**, qty_detail_pesanan, harga_satuan_detail)
6. `pembayaran` (**id_pembayaran**, id_pesanan, tgl_pembayaran, metode_pembayaran, bukti_pembayaran)

### Pemeriksaan BCNF
Pertanyaan pemeriksa: apakah ada penentu yang bukan kunci kandidat?

| Tabel | Penentu | Kunci kandidat? | Lolos BCNF |
| :--- | :--- | :--- | :---: |
| `kategori` | `id_kategori`, `nama_kategori` | Ya (keduanya) | Ya |
| `pelanggan` | `id_pelanggan`, `email_pelanggan` | Ya (keduanya) | Ya |
| `produk` | `id_produk`, `nama_produk` | Ya (keduanya) | Ya |
| `pesanan` | `id_pesanan`, `no_nota_pesanan` | Ya (keduanya) | Ya |
| `detail_pesanan` | (`id_pesanan`, `id_produk`) | Ya | Ya |
| `pembayaran` | `id_pembayaran`, `id_pesanan` | Ya (keduanya) | Ya |

Semua penentu adalah kunci kandidat, jadi skema memenuhi BCNF. Pemeriksaan ini hanya benar bila `nama_kategori`, `nama_produk`, dan `email_pelanggan` bernilai unik, dan ketiganya sudah bertanda UNIQUE di ERD.

---

## 8. Catatan Pembaruan ERD Proyek `toko_74`

Dari hasil normalisasi, ERD berubah pada lima titik:

| No | Perubahan | Alasan |
| :---: | :--- | :--- |
| 1 | Tabel `pelanggan` mendapat kolom `email_pelanggan` (UNIQUE, NOT NULL) | FD-03 dan AB-01: email adalah kunci alami pelanggan |
| 2 | `kategori.nama_kategori` dan `produk.nama_produk` ditandai UNIQUE | FD-04 dan FD-05: keduanya menjadi penentu, sehingga wajib unik agar lolos BCNF |
| 3 | Kolom `total_bayar` dihapus dari `pesanan` | FD-07: nilai turunan, dihitung lewat `v_total_pesanan` |
| 4 | Tabel `pesanan` mendapat kolom `status_pembayaran` (ENUM Pending, Lunas, Batal) | FD-01: status ada di nota dan menjadi dasar AB-06 serta AB-07 |
| 5 | `pembayaran.metode-pembayaran` diganti menjadi `metode_pembayaran` | Penulisan nama kolom seragam dengan garis bawah |

Tidak ada atribut `kode_*` di ERD. Setiap tabel memakai `id_*` sebagai kunci primer.

### Perbedaan dengan dokumen p02 (p02 tidak diubah)
Dokumen kebutuhan data p02 sudah dikumpulkan, sehingga aku tidak mengubahnya. Perubahan di atas tercatat di sini sebagai penyempurnaan hasil normalisasi:

- Kamus data p02 memuat `total_bayar` di `pesanan`. Setelah normalisasi, kolom itu dihitung lewat view (bagian 4).
- Kamus data p02 belum memuat `email_pelanggan`, padahal AB-01 mewajibkan email unik. Kolom itu ditambahkan di ERD.
- AB-09 (harga di nota tidak berubah meski harga katalog berubah) belum ada di p02. Aturan ini muncul dari FD-06 dan menjadi tambahan aturan bisnis.

### Catatan aturan qty
ERD tetap memakai `CHECK (qty_detail_pesanan > 0 AND qty_detail_pesanan <= 5)` sesuai kamus data p02 ("jumlah item dibeli, maks 5"). Batas ini membatasi jumlah per produk dan terpisah dari AB-04, yaitu maksimal 5 jenis produk per pesanan. Batas 5 jenis produk ditegakkan pada tahap implementasi (Pertemuan 5).

- *Bukti visual ERD update:* `laporan/img/p03_erd_toko_74_update.png`
