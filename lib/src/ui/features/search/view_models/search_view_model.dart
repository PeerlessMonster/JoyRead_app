import 'package:flutter/material.dart';

import '../../../../data/models/search_result.dart';
import '../../../../data/repositories/image.dart';
import '../../../../data/repositories/search.dart';
import '../../../../utils/http_client_proxy.dart';
import '../../../core/shared/background.dart';

class SearchViewModel extends ChangeNotifier {
  late final SearchRepository _newsRepository;
  late final ImageUrlRepository _imageRepository;

  SearchViewModel() {
    _imageRepository = const ImageUrlRepository();

    _httpClient = HttpClientProxyWithPersistentConnection();
    _newsRepository = SearchRepository(_httpClient);
  }

  late final HttpClientProxyWithPersistentConnection _httpClient;

  late Future<List<SearchResult>> _resultFuture;
  Future<List<SearchResult>> get resultFuture => _resultFuture;

  void search(String query) {
    _resultFuture = _newsRepository.load(query);

    _hasResult = true;
    notifyListeners();

    _lastQuery = query;
  }

  late String _lastQuery;

  void retrySearch() {
    _resultFuture = _newsRepository.load(_lastQuery);

    notifyListeners();
  }

  String loadImageUrl(String filename) => _imageRepository.loadNews(filename);

  Background loadFallbackImage() => BackgroundRandom.nextAsset();

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }

  var _hasResult = false;
  bool get hasResult => _hasResult;
}
