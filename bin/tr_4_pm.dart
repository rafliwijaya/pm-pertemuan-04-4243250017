import 'dart:async';

// SPESIFIKASI 1 & 2 HIRARKI KELAS KENDARAAN & MIXIN BERLANGGANAN
/// kls abstrak dasar untuk semua jenis kendaraan.
abstract class Kendaraan {
  final String plat;
  final DateTime waktuMasuk;
  Kendaraan(this.plat, this.waktuMasuk);
  String get jenis;
  int get tarifPerJam;

  /// hitung durasi parkir dn pembulatan ke atas (minimal 1 jam).
  int hitungDurasiJam(DateTime keluar) {
    final selisihMenit = keluar.difference(waktuMasuk).inMinutes;
    if (selisihMenit <= 0) return 1;
    final jam = (selisihMenit / 60).ceil();
    return jam < 1 ? 1 : jam;
  }
  int biaya(DateTime keluar) => hitungDurasiJam(keluar) * tarifPerJam;
}

/// mixin
mixin Berlangganan on Kendaraan {
  double get diskon => 0.50;
  @override
  String get jenis => '${super.jenis} (member)';
  @override
  int biaya(DateTime keluar) {
    final biayaNormal = super.biaya(keluar);
    return (biayaNormal * (1 - diskon)).round();
  }
}

/// subclass motor
class Motor extends Kendaraan {
  Motor(super.plat, super.waktuMasuk);
  @override
  String get jenis => 'Motor';
  @override
  int get tarifPerJam => 2000;
}

/// subclass mobil
class Mobil extends Kendaraan {
  Mobil(super.plat, super.waktuMasuk);
  @override
  String get jenis => 'Mobil';
  @override
  int get tarifPerJam => 5000;
}

/// subclass mobil mixin
class MobilMember extends Mobil with Berlangganan {
  MobilMember(super.plat, super.waktuMasuk);
}

/// subclass truk
class Truk extends Kendaraan {
  Truk(super.plat, super.waktuMasuk);
  @override
  String get jenis => 'Truk';
  @override
  int get tarifPerJam => 10000;
}

// SPESIFIKASI 3, 4, & 5 KELAS PARKIRAN, EXCEPTION, STREAM, & METHOD ASYNC
class ParkirPenuh implements Exception {
  final String pesan;
  ParkirPenuh(this.pesan);
  @override
  String toString() => 'Ditolak: $pesan';
}

/// kelass pengelola sistem parkir kampus
class Parkiran {
  final int kapasitas;
  final List<Kendaraan> _kendaraanTerparkir = [];
  int _pendapatan = 0;
  final _eventStreamController = StreamController<String>.broadcast();

  Parkiran({required this.kapasitas});
  int get sisa => kapasitas - _kendaraanTerparkir.length;
  int get pendapatan => _pendapatan;
  Stream<String> get eventStream => _eventStreamController.stream;
  Future<void> masuk(Kendaraan k) async {
    // simulasi respons sensor dan palang gerbang
    await Future.delayed(const Duration(milliseconds: 200));

    if (_kendaraanTerparkir.length >= kapasitas) {
      throw ParkirPenuh('Parkiran penuh (kapasitas $kapasitas)');
    }
    _kendaraanTerparkir.add(k);
    _eventStreamController.add('MASUK ${k.jenis} ${k.plat} (sisa $sisa)');
  }

  /// mehtod keluar async dengan simulasi palang gerbang dan penghitungan tarif
  Future<int> keluar(Kendaraan k, {DateTime? waktuKeluar}) async {
    // simulasi transaksi pos pembayaran dan palang keluar
    await Future.delayed(const Duration(milliseconds: 200));
    if (!_kendaraanTerparkir.contains(k)) {
      throw Exception('Kendaraan ${k.plat} tidak terdaftar di parkiran.');
    }
    final waktu = waktuKeluar ?? DateTime.now();
    final ongkos = k.biaya(waktu);

    _pendapatan += ongkos;
    _kendaraanTerparkir.remove(k);
    _eventStreamController.add('KELUAR ${k.jenis} ${k.plat} bayar Rp$ongkos');
    return ongkos;
  }

  Future<void> tutup() => _eventStreamController.close();
}

// SPEK 6 PROGRAM UTAMA (DEMONSTRASI POLIMORFISME, ASYNC, & EXCEPTION)
Future<void> main() async {
  // parkiran 3 slot
  final parkiran = Parkiran(kapasitas: 3);

  // listener stream layar monitor
  final langganan = parkiran.eventStream.listen((log) => print(log));

  // simulasi waktu masuk bersama
  final waktuMasukBersama = DateTime(2026, 10, 26, 8, 0);

  // demo polymoshrism
  final List<Kendaraan> antreanKendaraan = [
    Motor('BK 3811 AB', waktuMasukBersama),
    Mobil('BK 88 UN', waktuMasukBersama),
    MobilMember('BK 1 MIPA', waktuMasukBersama),
    Truk('BK 1091 AU', waktuMasukBersama),
  ];

  for (final kendaraan in antreanKendaraan) {
    try {
      await parkiran.masuk(kendaraan);
    } on ParkirPenuh catch (e) {
      print(e);
    }
  }

  // simulasi kluar parkir setelah 3 jam
  final waktuKeluarBersama = DateTime(2026, 10, 26, 11, 0);

  // proses keluar kendaaran
  await parkiran.keluar(antreanKendaraan[0], waktuKeluar: waktuKeluarBersama);
  await parkiran.keluar(antreanKendaraan[1], waktuKeluar: waktuKeluarBersama);
  await parkiran.keluar(antreanKendaraan[2], waktuKeluar: waktuKeluarBersama);
  await Future.delayed(const Duration(milliseconds: 50));

  // cetak pendapatan
  print('Pendapatan: Rp${parkiran.pendapatan}');
  await parkiran.tutup();
  await langganan.cancel();
}