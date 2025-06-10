import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class FavoritesProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> _filteredFavorites = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Map<String, dynamic>> get favorites => _searchQuery.isEmpty ? _favorites : _filteredFavorites;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _dbHelper.getFavorites();
      _filteredFavorites = _favorites;
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(Map<String, dynamic> character) async {
    try {
      final isFavorite = await _dbHelper.isFavorite(character['id']);
      
      if (isFavorite) {
        await _dbHelper.deleteFavorite(character['id']);
      } else {
        await _dbHelper.insertFavorite(character);
      }
      
      await loadFavorites();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      rethrow;
    }
  }

  Future<bool> isFavorite(int characterId) async {
    try {
      return await _dbHelper.isFavorite(characterId);
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
      return false;
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredFavorites = _favorites;
    } else {
      _filteredFavorites = _favorites
          .where((character) =>
              (character['name'] as String).toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
} 