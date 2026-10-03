-- p01_lingkungan_25430074.sql
-- Password sengaja diganti penanda. JANGAN commit password asli.

CREATE DATABASE IF NOT EXISTS kopma_074
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS toko_074
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- User Utama (sesuai modul/contoh dosen)
CREATE USER IF NOT EXISTS 'mhs_074'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON kopma_074.* TO 'mhs_074'@'localhost';

-- User Pengguna Praktikum
CREATE USER IF NOT EXISTS 'user_074'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON kopma_074.* TO 'user_074'@'localhost';

-- User Tamu (Read-Only)
CREATE USER IF NOT EXISTS 'tamu_074'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT SELECT ON kopma_074.* TO 'tamu_074'@'localhost';

-- User Pengembang Proyek Mandiri
CREATE USER IF NOT EXISTS 'dev_074'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON toko_074.* TO 'dev_074'@'localhost';

FLUSH PRIVILEGES;