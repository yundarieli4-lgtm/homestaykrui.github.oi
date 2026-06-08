class Homestay {
  final String id;
  final String nama;
  final String deskripsi;
  final String alamat;
  final double hargaPerMalam;
  final double rating;
  final String gambarUtama;
  final List<String> gambarLain;
  final List<String> fasilitas;
  final int kapasitas;
  final String pemilik;
  final String kontakPemilik;

  Homestay({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.alamat,
    required this.hargaPerMalam,
    required this.rating,
    required this.gambarUtama,
    this.gambarLain = const [],
    this.fasilitas = const [],
    required this.kapasitas,
    required this.pemilik,
    required this.kontakPemilik,
  });
}
