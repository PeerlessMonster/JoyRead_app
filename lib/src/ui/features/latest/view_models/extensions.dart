import '../../../../data/models/latest_news.dart';
import '../../../../data/services/image.dart';
import '../../../../utils/time.dart' as time;

extension Formatting on LatestNews {
  String get coverImageUrl => generateNewsImageUrl(coverImageFilename);

  String get formattedPublishTime => time.formatToLocal(publishUtc);
}
