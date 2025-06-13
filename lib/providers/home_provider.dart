import 'package:flutter/material.dart';
import '../services/MarvelApiService.dart';
import '../secreens/DetailsScreen.dart';
import '../models/MarvelCharacter.dart';

class HomeProvider extends ChangeNotifier {
  final MarvelApiService _apiService = MarvelApiService();
  List<MarvelCharacter> _characters = [];
  List<MarvelCharacter> _filteredCharacters = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  List<MarvelCharacter> get characters => _filteredCharacters;
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
      
      _characters = await _apiService.getCharacters();
      _filterCharacters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error loading characters';
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filterCharacters();
    notifyListeners();
  }

  void _filterCharacters() {
    if (_searchQuery.isEmpty) {
      _filteredCharacters = List.from(_characters);
    } else {
      _filteredCharacters = _characters
          .where((character) => character.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void onCharacterTap(BuildContext context, MarvelCharacter character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsScreen(character: character),
      ),
    );
  }
} 