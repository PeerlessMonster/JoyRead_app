import '../../utils/time.dart' as time;

class LatestNews {
  final String id;
  final String title;
  final DateTime publishUtc;
  final String coverImageFilename;

  const LatestNews(
      {required this.id,
      required this.title,
      required this.publishUtc,
      required this.coverImageFilename});

  factory LatestNews.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'id': String id,
          'title': String title,
          'publishUTCEpochMilli': String publishUtcMillisecondsSinceEpoch,
          'coverImgFilename': String coverImgFilename,
        } =>
          LatestNews(
              id: id,
              title: title,
              publishUtc: time.parse(publishUtcMillisecondsSinceEpoch),
              coverImageFilename: coverImgFilename),
        _ => throw const FormatException('Unexpected JSON format'),
      };
}
