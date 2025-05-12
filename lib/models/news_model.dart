class NewsModel {
  final String title;
  final String description;
  final String source;
  final String url;
  final String image;
  final String publishedAt;

  NewsModel({
    required this.title,
    required this.description,
    required this.source,
    required this.url,
    required this.image,
    required this.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      source: json['source'] ?? '',
      url: json['url'] ?? '',
      image: json['image'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
    );
  }
}
