class ComicItem {
  final String resourceURI;
  final String name;

  ComicItem({required this.resourceURI, required this.name});

  factory ComicItem.fromJson(Map<String, dynamic> json) {
    return ComicItem(
      resourceURI: json['resourceURI'],
      name: json['name'],
    );
  }
}
