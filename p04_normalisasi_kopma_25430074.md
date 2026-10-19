# p04: Normalisasi dan Skema Relasional Kopma Sejahtera

**Identitas Mahasiswa**
- **Nama:** Laelin Hidayaturrohma
- **NIM:** 25430074
- **Kelas:** C
- **Mata Kuliah:** Basis Data
- **Berkas:** `p04_normalisasi_kopma_25430074.md`

---

## 1. Anomali pada Spreadsheet Lama (Tujuan 1)

Spreadsheet lama Kopma menyimpan semua data dalam satu tabel besar (Gambar 4.1 modul):

| no_nota | tgl | kasir | anggota | barang | qty | harga | pemasok_brg |
| :--- | :--- | :--- | :--- | :--- | :---: | ---: | :--- |
| PJ-0142 | 24/09 | Rina | Budi S. | Pulpen Gel 0.5 | 3 | 4000 | CV Sumber ATK |
| PJ-0142 | 24/09 | Rina | Budi S. | Buku Tulis 58 | 2 | 6500 | CV Sumber ATK |
| PJ-0143 | 24/09 | Rina | - | Roti Cokelat | 2 | 5000 | UD Segar |
| PJ-0150 | 25/09 | Rina | Budi Santoso | Pulpen Gel 0.5 | 1 | 4500 | CV. Sumber A.T.K |

| Anomali | Bukti pada data | Akibat |
| :--- | :--- | :--- |
| Ubah | Anggota yang sama tertulis "Budi S." dan "Budi Santoso". Pemasok yang sama tertulis "CV Sumber ATK" dan "CV. Sumber A.T.K". | Satu fakta tersimpan di banyak baris dan bisa berbeda. Laporan per anggota atau per pemasok terpecah. |
| Sisip | Barang baru belum punya baris di spreadsheet sebelum ada penjualannya. | Kopma tidak bisa mencatat barang atau pemasok baru sebelum terjadi transaksi. |
| Hapus | Menghapus nota PJ-0143 ikut menghapus Roti Cokelat dan info pemasok UD Segar. | Data pemasok hilang bersama nota yang tidak sengaja dihapus. |

Normalisasi menghilangkan ketiganya dengan memisahkan setiap fakta ke tabel miliknya.

---

## 2. Langkah D.1: Dari UNF ke 1NF

### UNF
Satu nota menyimpan satu grup barang yang berulang (ditulis dalam `{ }`):

```
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan,
            harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan)
```

### 1NF
Aku menghapus grup berulang sehingga setiap nota memiliki satu baris untuk setiap barang. Kunci primernya menjadi gabungan `(no_nota_penjualan, kode_barang)`.

```
NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota, nama_barang, qty_detail_penjualan,
          harga_satuan_detail_penjualan, subtotal_detail_penjualan,
          jumlah_penjualan, diskon_penjualan, total_penjualan)
```

Nota PJ-0142 berubah dari satu record dengan dua barang menjadi dua baris:

| no_nota_penjualan | nama_anggota | nama_barang | qty_detail_penjualan | harga_satuan_detail_penjualan |
| :--- | :--- | :--- | :---: | ---: |
| PJ-0142 | Budi S. | Pulpen Gel 0.5 | 3 | 4000 |
| PJ-0142 | Budi S. | Buku Tulis 58 | 2 | 6500 |

Nama anggota ikut berulang di setiap baris. Pengulangan inilah yang 2NF dan 3NF hilangkan.

---

## 3. Langkah D.2: Dependensi Fungsional dari Aturan Bisnis

Aku menurunkan dependensi dari aturan bisnis Pertemuan 2, bukan dari contoh data.

| FD | Dependensi | Dasar aturan bisnis |
| :--- | :--- | :--- |
| FD1 | `no_nota_penjualan` -> `tgl_penjualan`, `kode_petugas`, `no_anggota` | AB-01: setiap nota punya nomor unik |
| FD2 | `kode_petugas` -> `nama_petugas` | Satu kode mewakili satu petugas |
| FD3 | `no_anggota` -> `nama_anggota` | AB-05: nomor anggota unik |
| FD4 | `kode_barang` -> `nama_barang` | Satu kode mewakili satu barang |
| FD5 | `(no_nota_penjualan, kode_barang)` -> `qty_detail_penjualan`, `harga_satuan_detail_penjualan` | AB-04: harga di nota tidak berubah meski harga katalog naik |
| FD6 | `qty_detail_penjualan`, `harga_satuan_detail_penjualan` -> `subtotal_detail_penjualan` | Nilai turunan (perkalian) |

`kode_barang -> harga_satuan_detail_penjualan` tidak masuk daftar. Contoh data memang menunjukkan Pulpen Gel 0.5 berharga 4000, tetapi nota PJ-0150 mencatat 4500. Dependensi itu salah karena satu barang punya lebih dari satu harga nota.

---

## 4. Nilai Turunan: Disimpan atau Dihitung?

| Atribut | Rumus | Keputusan |
| :--- | :--- | :--- |
| `subtotal_detail_penjualan` | `qty_detail_penjualan` x `harga_satuan_detail_penjualan` | Dihitung |
| `jumlah_penjualan` | jumlah semua subtotal dalam satu nota | Dihitung |
| `diskon_penjualan` | 5% x `jumlah_penjualan` bila anggota berstatus aktif (AB-02) | Dihitung |
| `total_penjualan` | `jumlah_penjualan` - `diskon_penjualan` | Dihitung |

Keempat atribut tidak muncul di tabel operasional dan tidak ada di ERD. Menyimpannya membuka anomali ubah: seseorang mengoreksi qty satu baris, lalu `total_penjualan` lama tetap tersimpan dan berbeda dari rincian nota.

Kueri yang menghitung total per nota (sudah kuuji dengan data PJ-0142 dan PJ-0143):

```sql
SELECT p.no_nota_penjualan,
       SUM(d.qty_detail_penjualan * d.harga_satuan) AS jumlah_penjualan,
       CASE WHEN a.status_anggota = 'aktif'
            THEN ROUND(SUM(d.qty_detail_penjualan * d.harga_satuan) * 0.05, 2)
            ELSE 0 END AS diskon_penjualan
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
LEFT JOIN anggota a ON a.id_anggota = p.id_anggota
GROUP BY p.id_penjualan, p.no_nota_penjualan, a.status_anggota;
```

`LEFT JOIN` dipakai karena penjualan boleh tanpa anggota (`id_anggota` bernilai NULL, AB-02).

---

## 5. Langkah D.3: Menuju 2NF dan 3NF

### 2NF
Kunci primer 1NF berupa gabungan, sehingga aku memeriksa ketergantungan parsial:

- FD1: `tgl_penjualan`, `kode_petugas`, dan `no_anggota` hanya bergantung pada `no_nota_penjualan`, separuh dari kunci gabungan. Atribut ini beserta `nama_petugas` dan `nama_anggota` pindah ke tabel `PENJUALAN`.
- FD4: `nama_barang` hanya bergantung pada `kode_barang`, separuh lainnya. Atribut ini pindah ke tabel `BARANG`.
- FD5: `qty_detail_penjualan` dan `harga_satuan_detail_penjualan` bergantung pada seluruh kunci gabungan, sehingga keduanya tetap di `DETAIL_PENJUALAN`.

```
PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota)
BARANG (kode_barang, nama_barang)
DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)
```

### 3NF
Tabel `PENJUALAN` masih menyimpan dua rantai transitif:

- `no_nota_penjualan` -> `kode_petugas` -> `nama_petugas` (FD1 dan FD2)
- `no_nota_penjualan` -> `no_anggota` -> `nama_anggota` (FD1 dan FD3)

Aku memisahkan petugas dan anggota ke tabel sendiri:

```
PETUGAS (kode_petugas, nama_petugas)
ANGGOTA (no_anggota, nama_anggota)
PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*)
BARANG (kode_barang, nama_barang)
DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)
-- kunci primer ditulis paling kiri (DETAIL_PENJUALAN: dua kolom pertama), * = kunci tamu
```

Atribut lain dari Pertemuan 2 masuk ke tabel yang sesuai: `peran_petugas` ke petugas, `harga_jual_barang` dan `stok_barang` ke barang, `status_anggota` dan `poin_loyalitas` ke anggota. `no_anggota` boleh kosong di `PENJUALAN` karena penjualan tanpa anggota diperbolehkan (AB-02).

### Ringkasan tahapan

| Tahap | Masalah yang ditemukan | Tindakan | Hasil |
| :--- | :--- | :--- | :--- |
| UNF | Grup barang berulang dalam satu nota | - | `NOTA_UNF` |
| 1NF | Satu nota berisi daftar barang | Satu baris per barang, kunci `(no_nota_penjualan, kode_barang)` | `NOTA_1NF` |
| 2NF | Data nota dan nama barang bergantung pada sebagian kunci | Pisah `PENJUALAN` dan `BARANG` | 3 tabel |
| 3NF | `nama_petugas` dan `nama_anggota` bergantung lewat kolom non-kunci | Pisah `PETUGAS` dan `ANGGOTA` | 5 tabel |

Sisi pembelian (`pemasok`, `pembelian`, `detail_pembelian`) muncul dari pemisahan `pemasok_brg` (Titik Analisis 3) dan dari proses PB-03 serta PB-04. Ketiganya melengkapi skema menjadi delapan tabel.

---

## 6. Langkah D.4: Mencocokkan dengan Skema Kanonik dan Memeriksa BCNF

### Skema akhir (sesuai ERD Pertemuan 3)

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
| :--- | :--- | :--- | :--- |
| `petugas` | `id_petugas` | - | - |
| `anggota` | `id_anggota` | `no_anggota`, `npm_anggota` | - |
| `barang` | `id_barang` | - | - |
| `pemasok` | `id_pemasok` | - | - |
| `penjualan` | `id_penjualan` | `no_nota_penjualan` | `id_petugas`, `id_anggota` (boleh NULL) |
| `detail_penjualan` | (`id_penjualan`, `id_barang`) | - | `id_penjualan`, `id_barang` |
| `pembelian` | `id_pembelian` | `no_faktur_pembelian` | `id_pemasok` |
| `detail_pembelian` | (`id_pembelian`, `id_barang`) | - | `id_pembelian`, `id_barang` |

### Perbedaan dengan skema hasil normalisasi (langkah 3NF)
1. **Kunci pengganti.** Setiap tabel memakai `id_*` sebagai kunci primer. Kunci alami yang tersisa, `no_nota_penjualan` dan `no_anggota`, menjadi kunci unik.
2. **`kode_petugas` dan `kode_barang` dihapus dari ERD.** Aku mengikuti arahan di kelas (latihan ERD puskesmas): bila sebuah tabel sudah memiliki `id_*`, kolom kode tidak dipakai lagi, karena satu pengenal sudah cukup. Kolom `id_petugas` dan `id_barang` mengidentifikasi setiap baris, sehingga dua kode itu menjadi kolom ganda. Tabel 4.2 mempertahankan keduanya sebagai kunci unik, sedangkan ERD-ku memilih satu pengenal saja. Akibatnya `petugas` dan `barang` tidak memiliki kunci unik alami, dan skema tetap memenuhi BCNF.
3. **NIM anggota** memakai nama kolom `npm_anggota` di ERD.
4. **Kolom tambahan** dari Pertemuan 2 (`peran_petugas`, `harga_jual_barang`, `stok_barang`, `status_anggota`, `poin_loyalitas`) tidak muncul di nota, tetapi ada di ERD.

### Pemeriksaan BCNF
Pertanyaan pemeriksa: apakah penentu yang bukan kunci kandidat ada di tabel ini?

| Tabel | Penentu | Kunci kandidat? | Lolos BCNF |
| :--- | :--- | :--- | :---: |
| `petugas` | `id_petugas` | Ya | Ya |
| `anggota` | `id_anggota`, `no_anggota`, `npm_anggota` | Ya (ketiganya) | Ya |
| `barang` | `id_barang` | Ya | Ya |
| `pemasok` | `id_pemasok` | Ya | Ya |
| `penjualan` | `id_penjualan`, `no_nota_penjualan` | Ya (keduanya) | Ya |
| `detail_penjualan` | (`id_penjualan`, `id_barang`) | Ya | Ya |
| `pembelian` | `id_pembelian`, `no_faktur_pembelian` | Ya (keduanya) | Ya |
| `detail_pembelian` | (`id_pembelian`, `id_barang`) | Ya | Ya |

Semua penentu adalah kunci kandidat, jadi skema memenuhi BCNF.

---

## 7. Jawaban Titik Analisis

### Titik Analisis 1: Mengapa FD5 menempatkan `harga_satuan_detail_penjualan` pada kunci `(no_nota_penjualan, kode_barang)` dan bukan pada `kode_barang` saja?

Harga nota adalah fakta tentang satu barang pada satu transaksi (AB-04). Pulpen Gel 0.5 terjual Rp4.000 di nota PJ-0142 dan Rp4.500 di nota PJ-0150, jadi `kode_barang` saja tidak menentukan harganya.

Seandainya kolom itu pindah ke tabel `barang` dan hanya menyimpan harga terbaru, omzet lama berubah ketika harga naik. Nota PJ-0142 menjual 3 pulpen. Dengan harga lama laporannya Rp12.000 (3 x 4.000). Setelah kolom harga barang menjadi 4.500, hitungan ulang memberi Rp13.500 (3 x 4.500). Omzet tahun lalu naik Rp1.500 untuk satu baris nota, padahal uang yang diterima Kopma tidak berubah.

### Titik Analisis 2: Mengapa keputusan "total tidak disimpan" kelak berbeda untuk arsip penjualan, dan mengapa keduanya konsisten?

Di tabel operasional, data pendukung total masih bisa berubah: qty dikoreksi, harga barang diperbarui, status anggota berganti dari aktif ke nonaktif (yang memengaruhi diskon, AB-02). Total yang tersimpan akan menyimpang dari rincian nota, sehingga aku menghitungnya setiap kali dibutuhkan.

Arsip penjualan menyimpan potret periode yang sudah ditutup. Nilainya tidak boleh berubah walau status anggota atau aturan diskon berubah kemudian. Menghitung ulang dari data yang sudah bergeser menghasilkan angka berbeda, sedangkan total yang tersimpan tetap sama dan laporan bulanan terbuka tanpa menghitung ulang ribuan baris.

Kedua keputusan memakai satu pegangan. Data operasional yang masih bisa berubah dihitung dari sumbernya, supaya selalu cocok dengan rincian. Potret historis yang tidak boleh berubah disimpan apa adanya.

### Titik Analisis 3: Kolom `pemasok_brg` tidak muncul di tabel `barang`. Di mana informasi "barang ini dipasok oleh siapa" kini disimpan, dan apa untungnya dibanding satu nama pemasok di tabel barang?

Informasi itu tersimpan lewat jalur `barang` -> `detail_pembelian` -> `pembelian` -> `pemasok`. Kueri berikut mengambilnya:

```sql
SELECT DISTINCT b.nama_barang, s.nama_pemasok
FROM barang b
JOIN detail_pembelian dp ON dp.id_barang = b.id_barang
JOIN pembelian pb ON pb.id_pembelian = dp.id_pembelian
JOIN pemasok s ON s.id_pemasok = pb.id_pemasok;
```

Keuntungannya:
- Satu barang boleh dipasok beberapa pemasok, dan satu pemasok boleh memasok banyak barang. Satu kolom nama pemasok tidak mampu menampung hubungan banyak-ke-banyak itu.
- Nama pemasok tersimpan sekali di `pemasok`. Salah ketik seperti "CV Sumber ATK" versus "CV. Sumber A.T.K" tidak bisa terjadi di banyak baris.
- Pemasok baru bisa dicatat sebelum ada barangnya (anomali sisip hilang).
- Menghapus satu nota penjualan tidak menghapus info pemasok (anomali hapus hilang).
- Harga beli berbeda per pembelian tersimpan di `detail_pembelian`.

---

## 8. Jawaban Latihan dan Modifikasi (Bagian E)

### E.1: Beberapa nomor telepon untuk setiap pemasok

Kolom `telepon_pemasok` di tabel `pemasok` hanya muat satu nilai. Menulis "0812xxxx, 0274xxxx" dalam satu kolom melanggar 1NF karena nilainya tidak atomik. Aku memindahkan nomor telepon ke tabel anak dan menghapus kolom itu dari `pemasok`.

Relasi baru:

```
PEMASOK (id_pemasok, nama_pemasok)
TELEPON_PEMASOK (id_pemasok*, no_telepon_pemasok)   -- kunci primer gabungan
```

```sql
CREATE TABLE telepon_pemasok (
  id_pemasok         INT         NOT NULL,
  no_telepon_pemasok VARCHAR(15) NOT NULL,
  PRIMARY KEY (id_pemasok, no_telepon_pemasok),
  FOREIGN KEY (id_pemasok) REFERENCES pemasok (id_pemasok)
);
```

Satu pemasok memiliki nol atau banyak nomor telepon (1:N). Kunci gabungan mencegah nomor yang sama tercatat dua kali untuk pemasok yang sama. Latihan ini tidak mengubah ERD Pertemuan 3 kecuali Kopma benar-benar mengadopsi kebutuhan nomor ganda.

### E.2: Pelanggaran 3NF bila `nama_anggota` disimpan di tabel penjualan

Contoh data tabel `penjualan` yang menyimpan `nama_anggota`:

| id_penjualan | no_nota_penjualan | id_anggota | nama_anggota |
| :---: | :--- | :---: | :--- |
| 1 | PJ-0142 | 7 | Budi S. |
| 2 | PJ-0150 | 7 | Budi S. |

Rantai `id_penjualan` -> `id_anggota` -> `nama_anggota` memuat kolom non-kunci (`id_anggota`) yang menentukan kolom non-kunci lain (`nama_anggota`). Itu ketergantungan transitif, sehingga tabel melanggar 3NF.

Anggota 7 mengoreksi namanya menjadi "Budi Santoso". Petugas mengubah nota yang sedang ia buka:

```sql
UPDATE penjualan
SET nama_anggota = 'Budi Santoso'
WHERE no_nota_penjualan = 'PJ-0150';
```

Hasilnya:

| id_penjualan | no_nota_penjualan | id_anggota | nama_anggota |
| :---: | :--- | :---: | :--- |
| 1 | PJ-0142 | 7 | Budi S. |
| 2 | PJ-0150 | 7 | Budi Santoso |

Kueri pemeriksa memperlihatkan anomali ubah:

```sql
SELECT id_anggota, COUNT(DISTINCT nama_anggota) AS jumlah_versi_nama
FROM penjualan
WHERE id_anggota IS NOT NULL
GROUP BY id_anggota
HAVING COUNT(DISTINCT nama_anggota) > 1;
-- hasil: id_anggota 7 memiliki 2 versi nama
```

Agar konsisten, petugas harus mengubah setiap nota milik anggota 7, dan satu baris yang terlewat menyisakan dua nama untuk satu orang. Pada rancangan 3NF nama tersimpan sekali, sehingga satu pernyataan memperbaikinya untuk semua nota:

```sql
UPDATE anggota SET nama_anggota = 'Budi Santoso' WHERE id_anggota = 7;
```
