import 'package:flutter/material.dart';

class DetailsScreenProvider extends ChangeNotifier {
  final Map<String, dynamic> character;

  DetailsScreenProvider(this.character);

  String get name => character['name'] as String;
  String get description => (character['description'] as String?) ?? '';
  String get imageUrl {
    final thumbnail = character['thumbnail'] as Map<String, dynamic>;
    return '${thumbnail['path']}.${thumbnail['extension']}';
  }
  // Ajoute ici d'autres getters pour comics, etc. si besoin
} 