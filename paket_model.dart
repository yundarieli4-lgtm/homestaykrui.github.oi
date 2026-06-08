class PaketEdukasi {
  final String id;
  final String nama;
  final String deskripsi;
  final double harga;
  final String gambar;
  final int durasiHari;
  final List<String> kegiatan;
  final String kategori;
  final int kuotaMin;
  final int kuotaMax;
  final String pemandu;
  final List<String> termasuk;
  final List<String> tidakTermasuk;

  PaketEdukasi({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.gambar,
    required this.durasiHari,
    this.kegiatan = const [],
    required this.kategori,
    required this.kuotaMin,
    required this.kuotaMax,
    required this.pemandu,
    this.termasuk = const [],
    this.tidakTermasuk = const [],
  });

  String get formattedHarga =>
      'Rp ${harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}
