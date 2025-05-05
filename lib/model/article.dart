import 'package:flutter_news_24_7/model/source.dart';

class Article {
  final Source source;
  final String? author;
  final String content;
  final String description;
  final DateTime publishedAt;
  final String title;
  final String url;
  final String urlToImage;

  Article({
    required this.source,
    required this.author,
    required this.content,
    required this.description,
    required this.publishedAt,
    required this.title,
    required this.url,
    required this.urlToImage,
  });

  @override
  List<Object?> get props => [
        source,
        author,
        content,
        description,
        publishedAt,
        title,
        url,
        urlToImage,
      ];

  Article.fromJson(Map<String, dynamic> json)
      : source = Source.fromJson(json["source"]),
        author = json["author"],
        title = json["title"],
        description = json["description"] ?? "",
        url = json["url"],
        urlToImage = json["urlToImage"] ?? "",
        publishedAt = DateTime.parse(json["publishedAt"]),
        content = json["content"] ?? "";
}
