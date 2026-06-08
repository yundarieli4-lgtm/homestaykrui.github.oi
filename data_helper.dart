import '../models/homestay_model.dart';
import '../models/paket_model.dart';

class DataHelper {
  static List<Homestay> getHomestays() {
    return [
      Homestay(
        id: 'hs001',
        nama: 'Surya Beach Homestay',
        deskripsi:
            'Homestay tepat di pinggir Pantai Labuhan Jukung dengan sunset memukau.',
        alamat: 'Jl. Pantai Labuhan Jukung, Pesisir Barat',
        hargaPerMalam: 350000,
        rating: 4.7,
        gambarUtama:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
        gambarLain: [
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
        ],
        fasilitas: ['WiFi', 'AC', 'Kamar Mandi Dalam', 'Sarapan', 'Parkir'],
        kapasitas: 2,
        pemilik: 'Bapak Wayan',
        kontakPemilik: '082178901234',
      ),
      Homestay(
        id: 'hs002',
        nama: 'Way Krui Bamboo Cottage',
        deskripsi:
            'Cottage bambu tradisional yang menyatu dengan alam perbukitan hijau.',
        alamat: 'Desa Way Krui, Pesisir Barat',
        hargaPerMalam: 275000,
        rating: 4.5,
        gambarUtama:
            'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800', // <-- URL Sudah Diperbaiki
        fasilitas: ['WiFi', 'Taman', 'Sarapan Tradisional'],
        kapasitas: 3,
        pemilik: 'Ibu Sari',
        kontakPemilik: '085267890123',
      ),
      Homestay(
        id: 'hs003',
        nama: 'Tanjung Setia Surf Camp',
        deskripsi:
            'Base camp para peselancar di spot surfing terbaik Sumatera.',
        alamat: 'Jl. Tanjung Setia, Pesisir Barat',
        hargaPerMalam: 200000,
        rating: 4.3,
        gambarUtama:
            'https://images.unsplash.com/photo-1528673456640-a5e36452c1f6?w=800', // Gambar papan surf di pantai
        fasilitas: ['WiFi', 'Penyewaan Surf', 'Ruang Hangout'],
        kapasitas: 4,
        pemilik: 'Mas Rizal',
        kontakPemilik: '081378901234',
      ),
      Homestay(
        id: 'hs004',
        nama: 'Mandiri Beach Villa',
        deskripsi:
            'Villa mewah dengan kolam renang pribadi dan pemandangan laut eksklusif.',
        alamat: 'Pantai Mandiri, Krui',
        hargaPerMalam: 750000,
        rating: 4.9,
        gambarUtama:
            'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
        fasilitas: ['WiFi', 'AC', 'Kolam Renang', 'Dapur', 'BBQ Area'],
        kapasitas: 6,
        pemilik: 'Bapak Hendra',
        kontakPemilik: '081178901234',
      ),
    ];
  }

  static List<PaketEdukasi> getPaketEdukasi() {
    return [
      PaketEdukasi(
        id: 'pk001',
        nama: 'Paket Mengenal Budaya Saibatin',
        deskripsi: 'Paket edukasi mendalam tentang sistem adat Saibatin.',
        harga: 850000,
        gambar:
            'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?w=800',
        durasiHari: 2,
        kegiatan: [
          'Kunjungan Balai Adat',
          'Dialog Pemangku Adat',
          'Workshop Tapis',
        ],
        kategori: 'Budaya',
        kuotaMin: 4,
        kuotaMax: 15,
        pemandu: 'Bapak Darmawan',
        termasuk: ['Penginapan 1 malam', 'Makan 3x', 'Sertifikat'],
        tidakTermasuk: ['Transportasi'],
      ),
      PaketEdukasi(
        id: 'pk002',
        nama: 'Paket Surfing & Pantai',
        deskripsi: 'Belajar surfing di spot terbaik Krui.',
        harga: 1200000,
        gambar:
            'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?w=800', // Gambar ombak besar surfing
        durasiHari: 3,
        kegiatan: [
          'Kelas dasar surfing',
          'Sunset session',
          'Nelayan experience',
        ],
        kategori: 'Petualangan',
        kuotaMin: 2,
        kuotaMax: 8,
        pemandu: 'Mas Rizal',
        termasuk: ['Penginapan 2 malam', 'Peralatan surf'],
        tidakTermasuk: ['Transportasi'],
      ),
      PaketEdukasi(
        id: 'pk003',
        nama: 'Paket Kuliner Krui',
        deskripsi: 'Eksplorasi kopi robusta dan kuliner tradisional.',
        harga: 650000,
        gambar:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
        durasiHari: 1,
        kegiatan: ['Tour kebun kopi', 'Cooking class'],
        kategori: 'Kuliner',
        kuotaMin: 4,
        kuotaMax: 12,
        pemandu: 'Ibu Sari',
        termasuk: ['Makan siang', 'Bahan workshop'],
        tidakTermasuk: ['Penginapan'],
      ),
    ];
  }

  static List<Map<String, String>> getMetodePembayaran() {
    return [
      {
        'id': 'bca',
        'nama': 'Bank BCA',
        'icon': '🏦',
        'norek': '1234567890',
        'atas_nama': 'Krui Homestay',
      },
      {
        'id': 'bri',
        'nama': 'Bank BRI',
        'icon': '🏦',
        'norek': '0987654321',
        'atas_nama': 'Krui Homestay',
      },
      {
        'id': 'gopay',
        'nama': 'GoPay',
        'icon': '💚',
        'norek': '082178901234',
        'atas_nama': 'Krui Homestay',
      },
    ];
  }
}
