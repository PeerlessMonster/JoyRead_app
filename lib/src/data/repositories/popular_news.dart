import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../data/exceptions/storage_exception.dart';
import '../../utils/error_handling.dart';
import '../../utils/http_client_proxy.dart';
import '../../utils/json.dart';
import '../models/popular_news.dart';
import '../services/news.dart';

class PopularNewsRepository {
  final HttpClientProxy _client;

  PopularNewsRepository(this._client);

  Future<List<PopularNews>> loadTodayWithCache(int count) async {
    const key = 'cache_todayPopularNews';
    final box = GetStorage();

    late String? responseBody;

    final result = await _client
        .fetch((client) => getTodayPopularNews(client, pageSize: count));
    switch (result) {
      case Error():
        if (result.error is! http.ClientException) {
          throw result.error;
        }

        responseBody = box.read<String>(key);
        if (responseBody == null) {
          throw const NoStorageDataException();
        }

      case Ok():
        responseBody = result.value;
        box.write(key, responseBody);
    }
    return jsonDecodeToList(responseBody, PopularNews.fromJson);
  }

  Future<List<PopularNews>> loadThisWeekWithCache(int count) async {
    const key = 'cache_thisWeekPopularNews';
    final box = GetStorage();

    late String? responseBody;

    final result = await _client
        .fetch((client) => getThisWeekPopularNews(client, pageSize: count));
    switch (result) {
      case Error():
        if (result.error is! http.ClientException) {
          throw result.error;
        }

        responseBody = box.read<String>(key);
        if (responseBody == null) {
          throw const NoStorageDataException();
        }

      case Ok():
        responseBody = result.value;
        box.write(key, responseBody);
    }
    return jsonDecodeToList(responseBody, PopularNews.fromJson);
  }
}
