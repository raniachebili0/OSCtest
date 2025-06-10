import 'package:flutter/material.dart';
import '../services/MarvelApiService.dart';
import '../secreens/DetailsScreen.dart';

class HomeProvider extends ChangeNotifier {
  final MarvelApiService _apiService = MarvelApiService();
  List<Map<String, dynamic>> _characters = [];
  List<Map<String, dynamic>> _filteredCharacters = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  List<Map<String, dynamic>> get characters => _searchQuery.isEmpty ? _characters : _filteredCharacters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  HomeProvider() {
    loadCharacters();
  }

  Future<void> loadCharacters() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      final characters = await _apiService.getCharacters();
      _characters = characters.map((character) => character as Map<String, dynamic>).toList();
      _filteredCharacters = _characters;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error loading characters';
      _isLoading = false;
      notifyListeners();
    }
  }

  void onCharacterTap(BuildContext context, Map<String, dynamic> character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsScreen(character: character),
      ),
    );
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredCharacters = _characters;
    } else {
      _filteredCharacters = _characters
          .where((character) =>
              (character['name'] as String).toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
} 