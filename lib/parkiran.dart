import 'dart:async';

import 'kendaraan.dart';

// Exception ketika kapasitas parkir penuh.
class ParkirPenuh implements Exception {
  final int kapasitas;

  ParkirPenuh(this.kapasitas);

  @override
  String toString() {
    return 'Parkiran penuh (kapasitas $kapasitas)';
  }
}

class Parkiran {
  final int kapasitas;

  // Data kendaraan bersifat private.
  final Map<String, Kendaraan> _kendaraan = {};

  int _pendapatan = 0;

  // Stream untuk mengirimkan aktivitas parkir.
  final StreamController<String> _aktivitasController =
      StreamController<String>.broadcast();

  Parkiran({required this.kapasitas});

  // Menghitung slot parkir yang tersisa.
  int get sisa => kapasitas - _kendaraan.length;

  // Mengambil total pendapatan.
  int get pendapatan => _pendapatan;

  // Stream aktivitas parkir.
  Stream<String> get aktivitas => _aktivitasController.stream;

  // Proses kendaraan masuk.
  Future<void> masuk(Kendaraan kendaraan) async {
    await Future.delayed(const Duration(seconds: 1));

    if (sisa <= 0) {
      throw ParkirPenuh(kapasitas);
    }

    if (_kendaraan.containsKey(kendaraan.plat)) {
      throw Exception('Kendaraan sudah berada di parkiran');
    }

    _kendaraan[kendaraan.plat] = kendaraan;

    _aktivitasController.add(
      'MASUK ${kendaraan.jenis} ${kendaraan.plat} (sisa $sisa)',
    );
  }

  // Proses kendaraan keluar.
  Future<void> keluar(String plat) async {
    await Future.delayed(const Duration(seconds: 1));

    final kendaraan = _kendaraan.remove(plat);

    if (kendaraan == null) {
      throw Exception('Kendaraan dengan plat $plat tidak ditemukan');
    }

    final biaya = kendaraan.biaya(DateTime.now());

    _pendapatan += biaya;

    _aktivitasController.add(
      'KELUAR ${kendaraan.jenis} ${kendaraan.plat} bayar Rp$biaya',
    );
  }

  // Menutup StreamController.
  Future<void> tutup() async {
    await _aktivitasController.close();
  }
}
