import 'ComicItem.dart';

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
      available: json['available'],
      collectionURI: json['collectionURI'],
      items: (json['items'] as List)
          .map((item) => ComicItem.fromJson(item))
          .toList(),
    );
  }
}
