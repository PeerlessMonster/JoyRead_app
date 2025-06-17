import 'package:flutter/material.dart';

import '../../../../data/models/news_detail.dart';
import '../../../../data/repositories/image.dart';
import '../../../../data/repositories/latest_news.dart';
import '../../../../utils/http_client_proxy.dart';
import '../../../core/shared/background.dart';

class MoreNewsViewModel extends ChangeNotifier {
  static const _pageSize = 18;
  int get pageSize => _pageSize;

  static const _preloadDataCount = 6;
  int get preloadDataCount => _preloadDataCount;

  static const _maxCachedPageCount = 2;
  int get maxCachedPageCount => _maxCachedPageCount;

  late final ImageUrlRepository _imageRepository;
  late final LatestNewsRepository _newsRepository;

  MoreNewsViewModel() {
    _imageRepository = const ImageUrlRepository();

    _httpClient = HttpClientProxyWithPersistentConnection();
    _newsRepository = LatestNewsRepository(_httpClient);

    _loadFirstPage();
  }

  late final HttpClientProxyWithPersistentConnection _httpClient;

  late Future<List<NewsDetail>> _firstPageFuture;
  Future<List<NewsDetail>> get firstPageFuture => _firstPageFuture;

  void _loadFirstPage() => _firstPageFuture = _newsRepository.load(_pageSize);

  void reloadFirstPage() {
    _loadFirstPage();

    notifyListeners();
  }

  Future<List<NewsDetail>> loadMorePage(int pageOrder) =>
      _newsRepository.load(_pageSize, pageOrder);

  String loadImageUrl(String filename) => _imageRepository.loadNews(filename);

  Background loadFallbackImage() => BackgroundRandom.nextAsset();

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }
}
