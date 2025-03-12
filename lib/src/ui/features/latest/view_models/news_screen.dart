import 'package:flutter/material.dart';

import '../../../../data/models/latest_news.dart';
import '../../../../data/repositories/latest_news.dart';
import '../../../../utils/http_client_proxy.dart';
import '../../../core/shared/background.dart';

class NewsScreenViewModel extends ChangeNotifier {
  static const _pageSize = 18;
  int get pageSize => _pageSize;

  static const _preloadDataCount = 6;
  int get preloadDataCount => _preloadDataCount;

  static const _maxCachedPageCount = 2;
  int get maxCachedPageCount => _maxCachedPageCount;

  Background get fallbackImage => BackgroundRandom.nextAsset();

  late final LatestNewsRepository _repository;

  NewsScreenViewModel() {
    _httpClient = HttpClientProxyWithPersistentConnection();
    _repository = LatestNewsRepository(_httpClient);

    _loadFirstPage();
  }

  late final HttpClientProxyWithPersistentConnection _httpClient;

  late Future<List<LatestNews>> firstPageFuture;

  void _loadFirstPage() =>
      firstPageFuture = _repository.loadLatestNews(_pageSize);

  void reloadFirstPage() {
    _loadFirstPage();

    notifyListeners();
  }

  Future<List<LatestNews>> loadMorePage(int pageOrder) =>
      _repository.loadLatestNews(_pageSize, pageOrder);

  @override
  void dispose() {
    _httpClient.close();

    super.dispose();
  }
}
