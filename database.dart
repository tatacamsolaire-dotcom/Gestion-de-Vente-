import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gestion_vente_ultra/models/product.dart';
import 'package:gestion_vente_ultra/models/sale.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    if(_db!=null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'gestion_vente_ultra.db');
    return await openDatabase(path, version:1, onCreate: (db, version) async {
      await db.execute("""
        CREATE TABLE products (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT,
          purchasePrice INTEGER,
          salePrice INTEGER,
          quantity INTEGER,
          imagePath TEXT
        )
      """);
      await db.execute("""
        CREATE TABLE sales (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          productId INTEGER,
          productName TEXT,
          quantity INTEGER,
          unitPrice INTEGER,
          clientName TEXT,
          clientCity TEXT,
          clientPhone TEXT,
          date TEXT
        )
      """);
    });
  }

  // Product CRUD
  Future<int> insertProduct(Product p) async {
    final db = await database;
    return await db.insert('products', p.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final maps = await db.query('products');
    return maps.map((m) => Product.fromMap(m)).toList();
  }

  Future<int> updateProduct(Product p) async {
    final db = await database;
    return await db.update('products', p.toMap(), where: 'id=?', whereArgs: [p.id]);
  }

  Future<int> deleteAllProducts() async {
    final db = await database;
    return await db.delete('products');
  }

  // Sales
  Future<int> insertSale(Sale s) async {
    final db = await database;
    return await db.insert('sales', s.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Sale>> getAllSales() async {
    final db = await database;
    final maps = await db.query('sales', orderBy: 'date DESC');
    return maps.map((m) => Sale.fromMap(m)).toList();
  }

  Future<int> deleteAllSales() async {
    final db = await database;
    return await db.delete('sales');
  }
}
