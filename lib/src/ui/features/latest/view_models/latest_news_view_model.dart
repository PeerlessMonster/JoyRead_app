import 'package:flutter/material.dart';

import '../../../../data/models/news_detail.dart';
import '../../../../data/repositories/image.dart';
import '../../../../data/repositories/latest_news.dart';
import '../../../../utils/http_client_proxy.dart';
import '../../../core/shared/background.dart';

class LatestNewsViewModel extends ChangeNotifier {
  static const _dataCount = 5;
  int get dataCount => _dataCount;

  final List<Background> fallbackImages;

  late final ImageUrlRepository _imageRepository;
  late final LatestNewsRepository _newsRepository;

  LatestNewsViewModel()
      : fallbackImages = BackgroundRandom.nextDistinctAssets(_dataCount) {
    _imageRepository = const ImageUrlRepository();

    final httpClient = HttpClientProxyWithDisposableConnection();
    _newsRepository = LatestNewsRepository(httpClient);

    _load();
  }

  late Future<List<NewsDetail>> dataFuture;

  void _load() =>
      dataFuture = _newsRepository.loadWithCache(_dataCount);

  void reload() {
    _load();

    notifyListeners();
  }

  String loadImageUrl(String filename) => _imageRepository.loadNews(filename);
}
