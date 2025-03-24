import 'package:flutter/material.dart';
import 'package:joyread/src/data/repositories/image.dart';

import '../../../../data/models/latest_news.dart';
import '../../../../data/repositories/latest_news.dart';
import '../../../../utils/http_client_proxy.dart';
import '../../../core/shared/background.dart';

class LatestNewsSlideshowViewModel extends ChangeNotifier {
  static const _slideshowCount = 5;

  int get slideshowCount => _slideshowCount;

  final List<Background> fallbackImages;

  late final ImageUrlRepository _imageRepository;
  late final LatestNewsRepository _newsRepository;

  LatestNewsSlideshowViewModel()
      : fallbackImages = BackgroundRandom.nextDistinctAssets(_slideshowCount) {
    _imageRepository = const ImageUrlRepository();

    final httpClient = HttpClientProxyWithDisposableConnection();
    _newsRepository = LatestNewsRepository(httpClient);

    _load();
  }

  late Future<List<LatestNews>> slideshowFuture;

  void _load() =>
      slideshowFuture = _newsRepository.loadAllWithCache(_slideshowCount);

  void reload() {
    _load();

    notifyListeners();
  }

  String loadImageUrl(String filename) => _imageRepository.news(filename);
}
