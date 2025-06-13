import 'package:flutter/material.dart';
import '../models/MarvelCharacter.dart';
import '../database/database_helper.dart';

class FavoritesProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<MarvelCharacter> _favorites = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<MarvelCharacter> get favorites => _favorites;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final favorites = await _databaseHelper.getFavorites();
      _favorites = favorites;
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite(MarvelCharacter character) async {
    try {
      await _databaseHelper.insertFavorite(character);
      _favorites.add(character);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding favorite: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite(int characterId) async {
    try {
      await _databaseHelper.deleteFavorite(characterId);
      _favorites.removeWhere((character) => character.id == characterId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing favorite: $e');
      rethrow;
    }
  }

  bool isFavorite(int characterId) {
    return _favorites.any((character) => character.id == characterId);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<MarvelCharacter> get filteredFavorites {
    if (_searchQuery.isEmpty) {
      return _favorites;
    }
    return _favorites.where((character) {
      return character.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }
} 