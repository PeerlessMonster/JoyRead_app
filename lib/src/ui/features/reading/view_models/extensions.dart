import '../../../../data/models/news.dart';
import '../../../../utils/time.dart' as time;

extension Formatting on News {
  String get formattedPublishTime => time.formatToLocal(publishUtc);
}
