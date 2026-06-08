import 'package:flutter/material.dart';

class FormatHelper {
  static String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  static String formatTanggal(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    const bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${bulan[date.month - 1]} ${date.year}';
  }

  static String generateNomorTransaksi() {
    final timestamp = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(4);
    return 'KRU-$timestamp';
  }

  static String getStatusText(String status) {
    if (status == 'lunas') return 'Lunas';
    return 'Menunggu';
  }

  static Color getStatusColor(String status) {
    if (status == 'lunas') return Colors.green;
    return Colors.orange;
  }
}
