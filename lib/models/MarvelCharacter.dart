import 'Comics.dart';
import 'Thumbnail.dart';

class MarvelCharacter {
  final int id;
  final String name;
  final String description;
  final String modified;
  final Thumbnail thumbnail;
  final String resourceURI;
  final Comics comics;

  MarvelCharacter({
    required this.id,
    required this.name,
    required this.description,
    required this.modified,
    required this.thumbnail,
    required this.resourceURI,
    required this.comics,
  });

  factory MarvelCharacter.fromJson(Map<String, dynamic> json) {
    return MarvelCharacter(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      modified: json['modified'],
      thumbnail: Thumbnail.fromJson(json['thumbnail']),
      resourceURI: json['resourceURI'],
      comics: Comics.fromJson(json['comics']),
    );
  }
}
