import 'package:pm_pertemuan_04_4243250043/kendaraan.dart';
import 'package:pm_pertemuan_04_4243250043/parkiran.dart';

Future<void> main() async {
  // Membuat parkiran dengan kapasitas 3 kendaraan.
  final parkiran = Parkiran(kapasitas: 3);

  // Mendengarkan setiap aktivitas parkir melalui Stream.
  final subscription = parkiran.aktivitas.listen((aktivitas) {
    print(aktivitas);
  });

  // Data kendaraan menggunakan List dengan tipe induk Kendaraan.
  // Ini merupakan contoh polymorphism.
  final List<Kendaraan> daftarKendaraan = [
    Motor(
      plat: 'BK 1234 AB',
      waktuMasuk: DateTime.now().subtract(
        const Duration(hours: 2),
      ),
    ),
    Mobil(
      plat: 'BK 88 UN',
      waktuMasuk: DateTime.now().subtract(
        const Duration(hours: 3),
      ),
    ),
    MobilMember(
      plat: 'BK 7 MIPA',
      waktuMasuk: DateTime.now().subtract(
        const Duration(hours: 3),
      ),
    ),
    Truk(
      plat: 'BK 9999 TR',
      waktuMasuk: DateTime.now(),
    ),
  ];

  print('=== SISTEM PARKIR KAMPUS FMIPA ===');

  // Simulasi kendaraan masuk.
  for (final kendaraan in daftarKendaraan) {
    try {
      await parkiran.masuk(kendaraan);
    } on ParkirPenuh catch (e) {
      print('Ditolak: $e');
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  print('\n=== PROSES KENDARAAN KELUAR ===');

  // Tiga kendaraan pertama keluar.
  for (final kendaraan in daftarKendaraan.take(3)) {
    try {
      await parkiran.keluar(kendaraan.plat);
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  // Menunggu Stream menyelesaikan pengiriman event terakhir.
  await Future<void>.delayed(const Duration(milliseconds: 100));

  // Menampilkan total pendapatan parkir.
  print('\nPendapatan: Rp${parkiran.pendapatan}');

  // Menutup Stream setelah seluruh aktivitas selesai.
  await subscription.cancel();
}
