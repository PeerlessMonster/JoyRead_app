import '../../utils/error_handling.dart';
import '../../utils/http_client_proxy.dart';
import '../../utils/json.dart';
import '../models/news.dart';
import '../services/news.dart';

class NewsRepository {
  final HttpClientProxy _client;

  NewsRepository(this._client);

  Future<News> loadOne(String id) async {
    final result = await _client.fetch((client) => getNews(client, id: id));
    switch (result) {
      case Ok():
        final responseBody = result.value;
        return jsonDecodeTo<News>(responseBody, News.fromJson);

      case Error():
        throw result.error;
    }
  }
}
