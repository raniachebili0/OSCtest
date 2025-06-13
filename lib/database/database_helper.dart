import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/MarvelCharacter.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'marvel_favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        character_id INTEGER PRIMARY KEY,
        character_data TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertFavorite(MarvelCharacter character) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'character_id': character.id,
        'character_data': jsonEncode(character.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavorite(int characterId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'character_id = ?',
      whereArgs: [characterId],
    );
  }

  Future<List<MarvelCharacter>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      final data = jsonDecode(maps[i]['character_data'] as String);
      return MarvelCharacter.fromJson(data);
    });
  }

  Future<bool> isFavorite(int characterId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'character_id = ?',
      whereArgs: [characterId],
    );
    return result.isNotEmpty;
  }
} 