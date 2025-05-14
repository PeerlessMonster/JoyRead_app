import '../../../../data/models/news_detail.dart';
import '../../../../utils/time.dart' as time;

extension Formatting on NewsDetail {
  String get formattedPublishTime => time.formatToLocal(publishUtc);
}
