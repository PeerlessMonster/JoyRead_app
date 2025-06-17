import '../../../../data/models/search_result.dart';
import '../../../../utils/time.dart' as time;

extension Formatting on SearchResult {
  String get formattedPublishTime => time.formatToLocal(publishUtc);
}
