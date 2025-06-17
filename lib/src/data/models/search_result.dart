import '../../utils/time.dart' as time;

class SearchResult {
  final String id;
  final String title;
  final String source;
  final List<String> hitSegments;
  final DateTime publishUtc;
  final String coverImageFilename;

  const SearchResult(
      {required this.id,
      required this.title,
      required this.source,
      required this.hitSegments,
      required this.publishUtc,
      required this.coverImageFilename});

  factory SearchResult.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'id': String id,
          'title': String title,
          'source': String source,
          'hitSegments': List<dynamic> hitSegments,
          'publishUTCEpochMilli': String publishUtcMillisecondsSinceEpoch,
          'coverImgFilename': String coverImgFilename,
        } =>
          SearchResult(
              id: id,
              title: title,
              source: source,
              hitSegments: hitSegments.cast<String>(),
              publishUtc: time.parse(publishUtcMillisecondsSinceEpoch),
              coverImageFilename: coverImgFilename),
        _ => throw const FormatException('Unexpected JSON format'),
      };
}
