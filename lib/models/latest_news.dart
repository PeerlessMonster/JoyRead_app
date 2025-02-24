class LatestNews {
  final String id;
  final String title;
  final String coverImgFilename;

  const LatestNews(
      {required this.id, required this.title, required this.coverImgFilename});

  factory LatestNews.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'title': String title,
        'coverImgFilename': String coverImgFilename
      } =>
        LatestNews(id: id, title: title, coverImgFilename: coverImgFilename),
      _ => throw const FormatException('Unexpected JSON format'),
    };
  }
}
