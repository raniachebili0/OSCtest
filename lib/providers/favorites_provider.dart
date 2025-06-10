import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class FavoritesProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> _filteredFavorites = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Map<String, dynamic>> get favorites => _filteredFavorites;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _dbHelper.getFavorites();
      _filterFavorites();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filterFavorites();
    notifyListeners();
  }

  void _filterFavorites() {
    if (_searchQuery.isEmpty) {
      _filteredFavorites = List.from(_favorites);
    } else {
      _filteredFavorites = _favorites
          .where((character) => character['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }
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
} 