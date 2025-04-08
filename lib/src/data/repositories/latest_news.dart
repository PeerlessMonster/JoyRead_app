import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/error_handling.dart';
import '../../utils/json.dart';
import '../../utils/http_client_proxy.dart';
import '../exceptions/storage_exception.dart';
import '../models/latest_news.dart';
import '../services/news.dart';

class LatestNewsRepository {
  final HttpClientProxy _client;

  LatestNewsRepository(this._client);

  Future<List<LatestNews>> load(int pageSize, [int pageOrder = 0]) async {
    final result = await _client.fetch((client) =>
        getLatestNews(client, pageSize: pageSize, pageOrder: pageOrder));
    switch (result) {
      case Ok():
        final responseBody = result.value;
        return jsonDecodeToList(responseBody, LatestNews.fromJson);

      case Error():
        throw result.error;
    }
  }

  Future<List<LatestNews>> loadWithCache(int count) async {
    const key = 'cache_latestNews';
    final box = GetStorage();

    late String? responseBody;

    final result =
        await _client.fetch((client) => getLatestNews(client, pageSize: count));
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
    return jsonDecodeToList(responseBody, LatestNews.fromJson);
  }
}
