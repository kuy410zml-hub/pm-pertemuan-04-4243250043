abstract class Kendaraan {
  final String plat;
  final DateTime waktuMasuk;

  Kendaraan({
    required this.plat,
    required this.waktuMasuk,
  });

  String get jenis;
  int get tarifPerJam;

  int biaya(DateTime keluar) {
    int lamaParkir =
        (keluar.difference(waktuMasuk).inMinutes / 60).ceil();

    if (lamaParkir < 1) {
      lamaParkir = 1;
    }

    return lamaParkir * tarifPerJam;
  }
}

// Mixin untuk pelanggan berlangganan.
mixin Berlangganan {
  int beriDiskon(int biaya) {
    return (biaya * 0.5).round();
  }
}

class Motor extends Kendaraan {
  Motor({
    required super.plat,
    required super.waktuMasuk,
  });

  @override
  String get jenis => 'Motor';

  @override
  int get tarifPerJam => 3000;
}

class Mobil extends Kendaraan {
  Mobil({
    required super.plat,
    required super.waktuMasuk,
  });

  @override
  String get jenis => 'Mobil';

  @override
  int get tarifPerJam => 5000;
}

class Truk extends Kendaraan {
  Truk({
    required super.plat,
    required super.waktuMasuk,
  });

  @override
  String get jenis => 'Truk';

  @override
  int get tarifPerJam => 8000;
}

// Mobil pelanggan berlangganan mendapatkan diskon 50%.
class MobilMember extends Kendaraan with Berlangganan {
  MobilMember({
    required super.plat,
    required super.waktuMasuk,
  });

  @override
  String get jenis => 'Mobil';

  @override
  int get tarifPerJam => 5000;

  @override
  int biaya(DateTime keluar) {
    return beriDiskon(super.biaya(keluar));
  }
}
