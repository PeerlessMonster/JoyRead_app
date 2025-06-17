import '../../utils/error_handling.dart';
import '../../utils/http_client_proxy.dart';
import '../../utils/json.dart';
import '../models/search_result.dart';
import '../services/search.dart';

class SearchRepository {
  final HttpClientProxy _client;

  SearchRepository(this._client);

  Future<List<SearchResult>> load(String query) async {
    final result =
        await _client.fetch((client) => getSearchResult(client, query: query));
    switch (result) {
      case Ok():
        final responseBody = result.value;
        return jsonDecodeToList(responseBody, SearchResult.fromJson);

      case Error():
        throw result.error;
    }
  }
}
