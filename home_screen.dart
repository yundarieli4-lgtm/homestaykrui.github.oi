import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../helpers/data_helper.dart';
import '../helpers/format_helper.dart';
import '../models/homestay_model.dart';
import '../models/paket_model.dart';
import '../models/pemesanan_model.dart';
import '../providers/pemesanan_provider.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  int _currentBanner = 0;
  Timer? _timer;

  final List<Map<String, String>> _banners = [
    {
      'img':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200',
      't': 'Pantai Labuhan Jukung',
      's': 'Sunset terindah',
    },
    {
      'img':
          'https://images.unsplash.com/photo-1502680390548-bdbac40b3029?w=1200',
      't': 'Surfing Tanjung Setia',
      's': 'Surf spot kelas dunia',
    },
    {
      'img':
          'https://images.unsplash.com/photo-1445019980597-93fa8acb246c?w=1200',
      't': 'Budaya Saibatin',
      's': 'Warisan leluhur',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted && _tab == 0) {
        setState(() {
          _currentBanner = (_currentBanner + 1) % _banners.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _switchTab(int i) {
    setState(() => _tab = i);
    if (i == 2) {
      context.read<PemesananProvider>().loadPemesanan();
    }
  }

  Widget _buildBeranda() {
    final homes = DataHelper.getHomestays().take(3).toList();
    final pkts = DataHelper.getPaketEdukasi().take(3).toList();

    return CustomScrollView(
      slivers: [
        // Banner
        SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: GestureDetector(
                    key: ValueKey(_currentBanner),
                    onTap: () => _switchTab(1),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: _banners[_currentBanner]['img']!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: Colors.grey[300]),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _banners[_currentBanner]['t']!,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                _banners[_currentBanner]['s']!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 16,
                  child: Row(
                    children: List.generate(_banners.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentBanner == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentBanner == i
                              ? Colors.amber
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Menu Cepat
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _qMenu(Icons.home_work, 'Homestay', Colors.teal, () {
                  _showListHome();
                }),
                const SizedBox(width: 12),
                _qMenu(Icons.school, 'Paket', Colors.orange, () {
                  _showListPaket();
                }),
                const SizedBox(width: 12),
                _qMenu(Icons.beach_access, 'Tentang Krui', Colors.blue, () {
                  _switchTab(1);
                }),
                const SizedBox(width: 12),
                _qMenu(Icons.receipt_long, 'Riwayat', Colors.purple, () {
                  _switchTab(2);
                }),
              ],
            ),
          ),
        ),

        // Galeri Pantai
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keindahan Pantai Krui',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _pantaiCard(
                        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600',
                        'Labuhan Jukung',
                      ),
                      _pantaiCard(
                        'https://images.unsplash.com/photo-1502680390548-bdbac40b3029?w=600',
                        'Tanjung Setia',
                      ),
                      _pantaiCard(
                        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600',
                        'Pantai Mandiri',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // Homestay Populer
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Homestay Populer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => _homestayCard(homes[i]),
            childCount: homes.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Paket Edukasi
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Paket Edukasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => _paketCard(pkts[i]),
            childCount: pkts.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }

  Widget _buildTentang() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Text(
          'Krui, Pesisir Barat',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        Text(
          'Lampung — Sumatera',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(height: 20),
        Text(
          'Krui adalah surga tersembunyi di pesisir barat Sumatera. Dengan ombak surfing kelas dunia, pantai berpasir putih, dan budaya Saibatin yang kaya.',
          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.8),
        ),
        SizedBox(height: 20),
        Text(
          '🏖️ Pantai',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          '• Pantai Labuhan Jukung: Sunset spektakuler\n• Tanjung Setia: Spot surfing terbaik\n• Pantai Mandiri: Villa eksklusif',
          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.8),
        ),
        SizedBox(height: 20),
        Text(
          '🎭 Budaya',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          '• Tari Sigeh Penguten\n• Kain Tapis (Diakui UNESCO)\n• Sistem Adat Saibatin',
          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.8),
        ),
      ],
    );
  }

  Widget _buildRiwayat() {
    return Consumer<PemesananProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.pemesananList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Belum ada pemesanan',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.pemesananList.length,
          itemBuilder: (_, i) {
            final p = provider.pemesananList[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: p.gambarItem,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.itemNama,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.nomorTransaksi,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            FormatHelper.formatRupiah(p.totalHarga),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showListHome() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, ctrl) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: ctrl,
              padding: const EdgeInsets.all(16),
              children: DataHelper.getHomestays().map((h) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailHomestayScreen(homestay: h),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: h.gambarUtama,
                            height: 160,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(height: 160, color: Colors.grey[300]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                h.nama,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rp ${h.hargaPerMalam.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}/malam',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _showListPaket() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, ctrl) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: ctrl,
              padding: const EdgeInsets.all(16),
              children: DataHelper.getPaketEdukasi().map((p) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPaketScreen(paket: p),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: p.gambar,
                            height: 140,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(height: 140, color: Colors.grey[300]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.nama,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    p.formattedHarga,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  const Text(
                                    '/orang',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _qMenu(IconData ic, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(ic, color: color, size: 24),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pantaiCard(String url, String nama) {
    return GestureDetector(
      onTap: () => _switchTab(1),
      child: Container(
        width: 190,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey[300]),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homestayCard(Homestay h) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailHomestayScreen(homestay: h)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: h.gambarUtama,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(width: 120, height: 120, color: Colors.grey[300]),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      h.nama,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${h.hargaPerMalam.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}/malam',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paketCard(PaketEdukasi p) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPaketScreen(paket: p)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: p.gambar,
                    height: 150,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(height: 150, color: Colors.grey[300]),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      p.kategori,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.nama,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        p.formattedHarga,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const Text(
                        '/orang',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Krui Homestay', 'Tentang Krui', 'Riwayat'];
    final icons = [Icons.home, Icons.beach_access, Icons.receipt_long];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(icons[_tab], color: Colors.amber, size: 24),
            const SizedBox(width: 10),
            Text(
              titles[_tab],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.teal.shade800,
        foregroundColor: Colors.white,
      ),
      body: _tab == 0
          ? _buildBeranda()
          : _tab == 1
          ? _buildTentang()
          : _buildRiwayat(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: _switchTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access),
            label: 'Tentang Krui',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}
