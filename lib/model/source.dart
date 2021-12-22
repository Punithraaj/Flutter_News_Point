class Source {
  String? category;
  String? country;
  String? description;
  String? id;
  String? language;
  String name;
  String? url;

  Source({
    required this.category,
    required this.country,
    required this.description,
    required this.id,
    required this.language,
    required this.name,
    required this.url,
  });

  Source.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        description = json["description"],
        url = json["url"],
        category = json["category"],
        country = json["country"],
        language = json["language"];
}
