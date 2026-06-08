import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pemesanan_model.dart';

class DatabaseHelper {
  static const String _databaseName = 'krui_homestay.db';
  static const int _databaseVersion = 1;
  static const String table = 'pemesanan';

  static Database? _database;
  static DatabaseHelper? _instance;
  DatabaseHelper._internal();
  static DatabaseHelper get instance =>
      _instance ??= DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $table (
      id TEXT PRIMARY KEY, jenis TEXT, itemId TEXT, itemNama TEXT, gambarItem TEXT,
      tanggalCheckin TEXT, tanggalCheckout TEXT, jumlahMalam INTEGER,
      jumlahTamu INTEGER, hargaSatuan REAL, totalHarga REAL, namaPemesan TEXT,
      noTelepon TEXT, email TEXT, metodePembayaran TEXT, statusPembayaran TEXT,
      nomorTransaksi TEXT, tanggalPesan TEXT, catatanKhusus TEXT
    )''');
  }

  Future<void> initDb() async {
    await database;
  }

  Future<List<Pemesanan>> getAllPemesanan() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      orderBy: 'tanggalPesan DESC',
    );
    return List.generate(maps.length, (i) => Pemesanan.fromMap(maps[i]));
  }

  Future<void> insertPemesanan(Pemesanan pemesanan) async {
    final db = await database;
    await db.insert(table, pemesanan.toMap());
  }
}
