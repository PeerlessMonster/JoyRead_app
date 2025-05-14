import '../../utils/time.dart' as time;

class NewsDetail {
  final String id;
  final String title;
  final DateTime publishUtc;
  final String coverImageFilename;

  const NewsDetail(
      {required this.id,
      required this.title,
      required this.publishUtc,
      required this.coverImageFilename});

  factory NewsDetail.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'id': String id,
          'title': String title,
          'publishUTCEpochMilli': String publishUtcMillisecondsSinceEpoch,
          'coverImgFilename': String coverImgFilename,
        } =>
          NewsDetail(
              id: id,
              title: title,
              publishUtc: time.parse(publishUtcMillisecondsSinceEpoch),
              coverImageFilename: coverImgFilename),
        _ => throw const FormatException('Unexpected JSON format'),
      };
}
