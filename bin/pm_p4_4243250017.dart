import 'dart:async';

import 'package:pm_p4_4243250017/model.dart';
import 'package:pm_p4_4243250017/perpustakaan.dart';

Future<void> main() async {
  print('DEMONSTRASI OOP LIBRARY SYSTEM - TANTANGAN');
  print('==================================================\n');

  final perpus = Perpustakaan('Perpustakaan FMIPA UNIMED');
  perpus.log.listen((pesan) => print('[LOG STREAM] $pesan'));

  // tmabha koleksi temrasuk skripsi
  perpus
    ..tambah(Buku('B01', 'Dasar-Dasar Dart', 'A. Siregar'))
    ..tambah(Majalah('M01', 'Majalah Sains & Komputer', 112))
    ..tambah(
      EBook(
        'E01',
        'Flutter in Action',
        'Eric Windmill',
        'https://dart.dev/ebooks/flutter',
      ),
    )
    ..tambah(
      Skripsi(
        'S01',
        'Penerapan Algoritma Genetika pada Optimasi Jadwal',
        'Budi Santoso',
        'Ilmu Komputer',
      ),
    );

  // menampilkan semua koleksi dan ikon dari sealed Class
  print(
    '\n--- Daftar Seluruh Koleksi beserta Ikon (Tantangan 3: Sealed Class) ---',
  );
  for (final k in perpus.semuaKoleksi) {
    print(
      '${ikon(k)} ${k.info()} | Lama Pinjam: ${k.lamaPinjam} hari | Status: ${k.tersedia ? "Tersedia" : "Dipinjam"}',
    );
  }

  final butet = Anggota('A01', 'Butet', maksPinjam: 1);
  final ucok = Anggota('A02', 'Ucok', maksPinjam: 2);

  // peminjaman normal
  print('\n--- Uji Peminjaman Normal ---');
  final p1 = await perpus.pinjam(butet, 'B01', tanggal: DateTime(2026, 10, 1));
  print('Peminjaman sukses: ${p1.koleksi.judul} oleh ${p1.anggota.nama}');

  // tes penolakan
  print('\n--- Uji Percobaan Peminjaman yang Ditolak ---');
  final daftarUji = [
    (ucok, 'S01', 'Uji Tantangan 2: Menolak peminjaman Skripsi'),
    (ucok, 'B01', 'Menolak meminjam buku yang sedang dipinjam'),
    (butet, 'M01', 'Menolak saat batas kuota pinjaman habis'),
    (ucok, 'X99', 'Menolak kode tidak ditemukan'),
  ];

  for (final (anggota, kode, skenario) in daftarUji) {
    print('\n[Skenario]: $skenario');
    try {
      await perpus.pinjam(anggota, kode);
    } on PeminjamanGagal catch (e) {
      print('Hasil Tangkapan Error: $e');
    }
  }

  // tes pengembalian koleksi
  print('\n--- Uji Pengembalian Koleksi ---');
  final denda = perpus.kembalikan(p1, tanggal: DateTime(2026, 10, 18));
  print('Pengembalian selesai. Denda: Rp$denda');

  await perpus.tutup();
}

// di dart privasi yg beraawalan _ bersifat library-private. ketika dipisah ke lib/perpustakaan.dart, pemanggilan k._dipinjam = true memicu compile-error. Solusinya, kita sediain method publik tandaiDipinjam() dan tandaiKembali() yang ada di file lib/model.dart
//karena Koleksi bersifat sealed, Dart menerapkan Exhaustiveness checking. Jika salah satu subclass dihapus dari switch (misalnya case Skripsi()), compiler akan langsung menolak kompilasi dengan error
