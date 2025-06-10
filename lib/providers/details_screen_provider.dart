import 'package:flutter/material.dart';
import '../services/MarvelApiService.dart';

class DetailsScreenProvider extends ChangeNotifier {
  final Map<String, dynamic> character;
  final MarvelApiService _apiService = MarvelApiService();
  List<Map<String, dynamic>> _comics = [];
  bool _isLoadingComics = false;
  String? _comicsError;

  DetailsScreenProvider(this.character) {
    loadComics();
  }

  String get name => character['name'] as String;
  String get description => (character['description'] as String?) ?? '';
  String get imageUrl {
    final thumbnail = character['thumbnail'] as Map<String, dynamic>;
    return '${thumbnail['path']}.${thumbnail['extension']}';
  }
  List<Map<String, dynamic>> get comics => _comics;
  bool get isLoadingComics => _isLoadingComics;
  String? get comicsError => _comicsError;

  Future<void> loadComics() async {
    try {
      _isLoadingComics = true;
      _comicsError = null;
      notifyListeners();

      final comics = await _apiService.getCharacterComics(character['id']);
      _comics = comics.map((comic) => comic as Map<String, dynamic>).toList();
      
      _isLoadingComics = false;
      notifyListeners();
    } catch (e) {
      _comicsError = 'Failed to load comics';
      _isLoadingComics = false;
      notifyListeners();
    }
  }
} 