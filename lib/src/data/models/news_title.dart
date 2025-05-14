class NewsTitle {
  final String id;
  final String title;

  const NewsTitle({required this.id, required this.title});

  factory NewsTitle.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'id': String id,
          'title': String title,
        } =>
          NewsTitle(id: id, title: title),
        _ => throw const FormatException('Unexpected JSON format'),
      };

  static List<NewsTitle> fromJsonList(List<dynamic> jsonList) => jsonList
      .cast<Map<String, dynamic>>()
      .map((json) => NewsTitle.fromJson(json))
      .toList();
}
