import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/homestay_model.dart';
import '../models/paket_model.dart';
import '../models/pemesanan_model.dart';
import '../helpers/format_helper.dart';
import '../helpers/data_helper.dart';
import '../providers/pemesanan_provider.dart';
import 'home_screen.dart';

class BookingScreen extends StatefulWidget {
  final String jenis;
  final dynamic item;
  const BookingScreen({super.key, required this.jenis, required this.item});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _step = 0;
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _telpCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  DateTime _checkin = DateTime.now().add(const Duration(days: 1));
  DateTime _checkout = DateTime.now().add(const Duration(days: 2));
  int _tamu = 1;
  double _total = 0;
  String? _metodeId;
  bool _loading = false;
  Pemesanan? _result;

  @override
  void initState() {
    super.initState();
    _hitung();
  }

  void _hitung() {
    if (widget.jenis == 'homestay') {
      final h = widget.item as Homestay;
      _total =
          h.hargaPerMalam * _checkout.difference(_checkin).inDays.clamp(1, 30);
    } else {
      final p = widget.item as PaketEdukasi;
      _total = p.harga * _tamu;
    }
    setState(() {});
  }

  void _pickDate(bool isIn) async {
    DateTime initial = isIn ? _checkin : _checkout;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    if (isIn) {
      _checkin = picked;
      if (!_checkout.isAfter(_checkin)) {
        _checkout = _checkin.add(const Duration(days: 1));
      }
    } else {
      if (picked.isAfter(_checkin)) {
        _checkout = picked;
      }
    }
    _hitung();
  }

  void _bayar() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    final m = DataHelper.getMetodePembayaran().firstWhere(
      (m) => m['id'] == _metodeId,
    );

    String itemId;
    String itemNama;
    String gambarItem;
    double hargaSatuan;
    int jumlahMalam;

    if (widget.jenis == 'homestay') {
      final h = widget.item as Homestay;
      itemId = h.id;
      itemNama = h.nama;
      gambarItem = h.gambarUtama;
      hargaSatuan = h.hargaPerMalam;
      jumlahMalam = _checkout.difference(_checkin).inDays.clamp(1, 30);
    } else {
      final p = widget.item as PaketEdukasi;
      itemId = p.id;
      itemNama = p.nama;
      gambarItem = p.gambar;
      hargaSatuan = p.harga;
      jumlahMalam = p.durasiHari;
    }

    final pemesanan = Pemesanan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      jenis: widget.jenis,
      itemId: itemId,
      itemNama: itemNama,
      gambarItem: gambarItem,
      tanggalCheckin: _checkin.toIso8601String(),
      tanggalCheckout: _checkout.toIso8601String(),
      jumlahMalam: jumlahMalam,
      jumlahTamu: _tamu,
      hargaSatuan: hargaSatuan,
      totalHarga: _total,
      namaPemesan: _namaCtrl.text,
      noTelepon: _telpCtrl.text,
      email: _emailCtrl.text,
      metodePembayaran: '${m['icon']} ${m['nama']}',
      statusPembayaran: 'lunas',
      nomorTransaksi: FormatHelper.generateNomorTransaksi(),
      tanggalPesan: DateTime.now().toIso8601String(),
    );

    if (mounted) {
      await context.read<PemesananProvider>().tambahPemesanan(pemesanan);
      setState(() {
        _result = pemesanan;
        _loading = false;
        _step = 2;
      });
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _telpCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_step == 0) return true;
        setState(() => _step--);
        return false;
      },
      child: Scaffold(
        appBar: _step < 2
            ? AppBar(
                title: Text(
                  _step == 0 ? 'Form Pemesanan' : 'Pembayaran',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.teal.shade800,
                foregroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (_step == 0) {
                      Navigator.pop(context);
                    } else {
                      setState(() => _step--);
                    }
                  },
                ),
              )
            : null,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: Colors.white,
              child: Row(
                children: List.generate(3, (i) {
                  return Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: i == _step ? 32 : 26,
                                    height: i == _step ? 32 : 26,
                                    decoration: BoxDecoration(
                                      color: i <= _step
                                          ? Colors.teal
                                          : Colors.grey[300],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${i + 1}',
                                        style: TextStyle(
                                          fontSize: i == _step ? 14 : 12,
                                          fontWeight: FontWeight.bold,
                                          color: i <= _step
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (i < 2)
                                    Expanded(
                                      child: Container(
                                        height: 3,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        color: i < _step
                                            ? Colors.teal
                                            : Colors.grey[300],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ['Data', 'Bayar', 'Selesai'][i],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: i == _step
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: i <= _step ? Colors.teal : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: _step == 0
                  ? _buildForm()
                  : _step == 1
                  ? _buildPayment()
                  : _buildStruk(),
            ),
          ],
        ),
        bottomSheet: _buildBottomButton(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.jenis == 'homestay' ? '🏠 Homestay' : '🎓 Paket',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.jenis == 'homestay'
                      ? (widget.item as Homestay).nama
                      : (widget.item as PaketEdukasi).nama,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (widget.jenis == 'homestay') ...[
            const Text(
              'Check-in',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _pickDate(true),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.teal,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      FormatHelper.formatTanggal(_checkin.toIso8601String()),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Check-out',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _pickDate(false),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.teal,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      FormatHelper.formatTanggal(_checkout.toIso8601String()),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ] else
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event, color: Colors.orange),
                  const SizedBox(width: 10),
                  Text(
                    'Durasi: ${(widget.item as PaketEdukasi).durasiHari} Hari',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 18),
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (_tamu > 1) {
                    setState(() => _tamu--);
                    _hitung();
                  }
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.remove, color: Colors.teal),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 60,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$_tamu',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {
                  setState(() => _tamu++);
                  _hitung();
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add, color: Colors.teal),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Tamu',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(),
          const Text(
            'Data Pemesan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _namaCtrl,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _telpCtrl,
            decoration: const InputDecoration(
              labelText: 'No. Telepon',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailCtrl,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            validator: (v) =>
                v!.isEmpty || !v.contains('@') ? 'Email tidak valid' : null,
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rincian Harga',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total: ${FormatHelper.formatRupiah(_total)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPayment() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total Bayar: ${FormatHelper.formatRupiah(_total)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Pilih Metode Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...DataHelper.getMetodePembayaran().map((m) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => setState(() => _metodeId = m['id']),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _metodeId == m['id']
                      ? Colors.teal.shade50
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _metodeId == m['id']
                        ? Colors.teal
                        : Colors.grey[300]!,
                    width: _metodeId == m['id'] ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(m['icon']!, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m['nama']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'No.Rek: ${m['norek']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: m['id']!,
                      groupValue: _metodeId,
                      onChanged: (v) => setState(() => _metodeId = v),
                      activeColor: Colors.teal,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildStruk() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 16),
          const Text(
            'Pembayaran Lunas!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _result?.nomorTransaksi ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Total: ${FormatHelper.formatRupiah(_result?.totalHarga ?? 0)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Terima kasih telah memilih Krui Homestay 🌊',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    if (_step == 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() => _step = 1);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Lanjut ke Pembayaran',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    } else if (_step == 1) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _metodeId == null || _loading ? null : _bayar,
            style: ElevatedButton.styleFrom(
              backgroundColor: _metodeId != null
                  ? Colors.teal.shade800
                  : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Bayar Sekarang',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (r) => r.isFirst,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Ke Beranda',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
  }
}
