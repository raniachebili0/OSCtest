import 'package:flutter/material.dart';
import '../services/MarvelApiService.dart';
import '../secreens/DetailsScreen.dart';

class HomeProvider extends ChangeNotifier {
  final MarvelApiService _apiService = MarvelApiService();
  List<Map<String, dynamic>> _characters = [];
  bool _isLoading = true;
  String? _error;

  List<Map<String, dynamic>> get characters => _characters;
  bool get isLoading => _isLoading;
  String? get error => _error;

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
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors du chargement des personnages';
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
} 