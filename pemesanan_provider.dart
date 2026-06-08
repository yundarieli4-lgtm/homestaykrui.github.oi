import 'package:flutter/material.dart';
import '../models/pemesanan_model.dart';
import '../helpers/database_helper.dart';

class PemesananProvider with ChangeNotifier {
  List<Pemesanan> _pemesananList = [];
  bool _isLoading = true;

  List<Pemesanan> get pemesananList => _pemesananList;
  bool get isLoading => _isLoading;

  Future<void> loadPemesanan() async {
    _isLoading = true;
    notifyListeners();
    _pemesananList = await DatabaseHelper.instance.getAllPemesanan();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> tambahPemesanan(Pemesanan pemesanan) async {
    await DatabaseHelper.instance.insertPemesanan(pemesanan);
    await loadPemesanan();
  }
}
