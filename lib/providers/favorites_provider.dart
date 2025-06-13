import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/MarvelCharacter.dart';

class FavoritesProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<MarvelCharacter> _favorites = [];
  List<MarvelCharacter> _filteredFavorites = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<MarvelCharacter> get favorites => _filteredFavorites;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final rawFavorites = await _dbHelper.getFavorites();
      _favorites = rawFavorites.map((json) => MarvelCharacter.fromJson(json)).toList();
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
          .where((character) => character.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  Future<void> toggleFavorite(MarvelCharacter character) async {
    try {
      final isFavorite = await _dbHelper.isFavorite(character.id);
      
      if (isFavorite) {
        await _dbHelper.deleteFavorite(character.id);
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