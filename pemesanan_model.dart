class Pemesanan {
  final String id;
  final String jenis;
  final String itemId;
  final String itemNama;
  final String gambarItem;
  final String tanggalCheckin;
  final String tanggalCheckout;
  final int jumlahMalam;
  final int jumlahTamu;
  final double hargaSatuan;
  final double totalHarga;
  final String namaPemesan;
  final String noTelepon;
  final String email;
  final String metodePembayaran;
  final String statusPembayaran;
  final String nomorTransaksi;
  final String tanggalPesan;
  final String? catatanKhusus;

  Pemesanan({
    required this.id,
    required this.jenis,
    required this.itemId,
    required this.itemNama,
    required this.gambarItem,
    required this.tanggalCheckin,
    required this.tanggalCheckout,
    required this.jumlahMalam,
    required this.jumlahTamu,
    required this.hargaSatuan,
    required this.totalHarga,
    required this.namaPemesan,
    required this.noTelepon,
    required this.email,
    required this.metodePembayaran,
    required this.statusPembayaran,
    required this.nomorTransaksi,
    required this.tanggalPesan,
    this.catatanKhusus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jenis': jenis,
      'itemId': itemId,
      'itemNama': itemNama,
      'gambarItem': gambarItem,
      'tanggalCheckin': tanggalCheckin,
      'tanggalCheckout': tanggalCheckout,
      'jumlahMalam': jumlahMalam,
      'jumlahTamu': jumlahTamu,
      'hargaSatuan': hargaSatuan,
      'totalHarga': totalHarga,
      'namaPemesan': namaPemesan,
      'noTelepon': noTelepon,
      'email': email,
      'metodePembayaran': metodePembayaran,
      'statusPembayaran': statusPembayaran,
      'nomorTransaksi': nomorTransaksi,
      'tanggalPesan': tanggalPesan,
      'catatanKhusus': catatanKhusus,
    };
  }

  factory Pemesanan.fromMap(Map<String, dynamic> map) {
    return Pemesanan(
      id: map['id'],
      jenis: map['jenis'],
      itemId: map['itemId'],
      itemNama: map['itemNama'],
      gambarItem: map['gambarItem'],
      tanggalCheckin: map['tanggalCheckin'],
      tanggalCheckout: map['tanggalCheckout'],
      jumlahMalam: map['jumlahMalam'],
      jumlahTamu: map['jumlahTamu'],
      hargaSatuan: map['hargaSatuan'],
      totalHarga: map['totalHarga'],
      namaPemesan: map['namaPemesan'],
      noTelepon: map['noTelepon'],
      email: map['email'],
      metodePembayaran: map['metodePembayaran'],
      statusPembayaran: map['statusPembayaran'],
      nomorTransaksi: map['nomorTransaksi'],
      tanggalPesan: map['tanggalPesan'],
      catatanKhusus: map['catatanKhusus'],
    );
  }
}
