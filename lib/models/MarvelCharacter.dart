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
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      modified: json['modified'] as String,
      thumbnail: Thumbnail.fromJson(json['thumbnail'] as Map<String, dynamic>),
      resourceURI: json['resourceURI'] as String,
      comics: Comics.fromJson(json['comics'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'modified': modified,
      'thumbnail': thumbnail.toJson(),
      'resourceURI': resourceURI,
      'comics': comics.toJson(),
    };
  }
}

class Thumbnail {
  final String path;
  final String extension;

  Thumbnail({
    required this.path,
    required this.extension,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      path: json['path'] as String,
      extension: json['extension'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'extension': extension,
    };
  }
}

class Comics {
  final int available;
  final String collectionURI;
  final List<ComicItem> items;

  Comics({
    required this.available,
    required this.collectionURI,
    required this.items,
  });

  factory Comics.fromJson(Map<String, dynamic> json) {
    return Comics(
      available: json['available'] as int,
      collectionURI: json['collectionURI'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => ComicItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'collectionURI': collectionURI,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ComicItem {
  final String resourceURI;
  final String name;

  ComicItem({
    required this.resourceURI,
    required this.name,
  });

  factory ComicItem.fromJson(Map<String, dynamic> json) {
    return ComicItem(
      resourceURI: json['resourceURI'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resourceURI': resourceURI,
      'name': name,
    };
  }
}
