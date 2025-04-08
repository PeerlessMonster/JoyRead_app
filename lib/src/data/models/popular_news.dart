class PopularNews {
  final String id;
  final String title;

  PopularNews({required this.id, required this.title});

  factory PopularNews.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'id': String id,
          'title': String title,
        } =>
          PopularNews(id: id, title: title),
        _ => throw const FormatException('Unexpected JSON format'),
      };
}
