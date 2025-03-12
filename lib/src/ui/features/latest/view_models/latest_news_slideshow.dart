import 'package:flutter/material.dart';

import '../../../../data/models/latest_news.dart';
import '../../../../data/repositories/latest_news.dart';
import '../../../../utils/http_client_proxy.dart';
import '../../../core/shared/background.dart';

class LatestNewsSlideshowViewModel extends ChangeNotifier {
  static const _slideshowCount = 5;
  int get slideshowCount => _slideshowCount;

  final List<Background> fallbackImages;

  late final LatestNewsRepository _repository;

  LatestNewsSlideshowViewModel()
      : fallbackImages = BackgroundRandom.nextDistinctAssets(_slideshowCount) {
    final httpClient = HttpClientProxyWithDisposableConnection();
    _repository = LatestNewsRepository(httpClient);

    _load();
  }

  late Future<List<LatestNews>> slideshowFuture;

  void _load() {
    slideshowFuture = _repository.loadLatestNewsWithCache(_slideshowCount);
  }

  void reload() {
    _load();

    notifyListeners();
  }
}
