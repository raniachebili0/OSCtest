import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static const int _databaseVersion = 2; // Increment version number

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Delete existing database if version is old
    await _deleteOldDatabase();
    
    String path = join(await getDatabasesPath(), 'marvel_favorites.db');
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _deleteOldDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final dbFile = File(join(dbPath, 'marvel_favorites.db'));
      if (await dbFile.exists()) {
        await dbFile.delete();
      }
    } catch (e) {
      print('Error deleting old database: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY,
        character_id INTEGER,
        character_data TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop the old table and create the new one
      await db.execute('DROP TABLE IF EXISTS favorites');
      await _onCreate(db, newVersion);
    }
  }

  Future<int> insertFavorite(Map<String, dynamic> character) async {
    final db = await database;
    return await db.insert('favorites', {
      'character_id': character['id'],
      'character_data': jsonEncode(character),
    });
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'favorites',
      orderBy: 'created_at DESC',
    );
    
    return results.map((row) {
      final characterData = jsonDecode(row['character_data'] as String);
      return characterData as Map<String, dynamic>;
    }).toList();
  }

  Future<int> deleteFavorite(int characterId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'character_id = ?',
      whereArgs: [characterId],
    );
  }

  Future<bool> isFavorite(int characterId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'character_id = ?',
      whereArgs: [characterId],
    );
    return result.isNotEmpty;
  }
} 