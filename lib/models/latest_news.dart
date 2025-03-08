class LatestNews {
  final String id;
  final String title;
  final DateTime publishTime;
  final String coverImageFilename;

  LatestNews(
      {required this.id,
      required this.title,
      required this.publishTime,
      required this.coverImageFilename});

  factory LatestNews.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'id': String id,
          'title': String title,
          'publishEpochMillisecond': String publishEpochMillisecond,
          'coverImgFilename': String coverImgFilename
        } =>
          LatestNews(
              id: id,
              title: title,
              publishTime: DateTime.fromMillisecondsSinceEpoch(
                  int.parse(publishEpochMillisecond),
                  isUtc: true),
              coverImageFilename: coverImgFilename),
        _ => throw const FormatException('Unexpected JSON format'),
      };
}
