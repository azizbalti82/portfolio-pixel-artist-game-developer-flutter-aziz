class PixelArtPortfolioItem {
  final String id; // unique id
  final String title; // name of the work
  final String description; // small description
  final String imageUrl; // image path/url
  final bool isPixelArt; // true if it's pixel art work
  final String type;

  PixelArtPortfolioItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.isPixelArt,
    required this.type,
  });

  // Factory to create from JSON
  factory PixelArtPortfolioItem.fromJson(Map<String, dynamic> json) {
    return PixelArtPortfolioItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      isPixelArt: json['isPixelArt'],
      type: json['type'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'isPixelArt': isPixelArt,
      'type': type,
    };
  }
}
