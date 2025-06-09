import 'package:flutter/material.dart';

import '../../../../data/models/news.dart';
import '../../../../data/repositories/image.dart';
import '../../../../data/repositories/news.dart';
import '../../../../utils/http_client_proxy.dart';
import '../../../core/shared/background.dart';

class ReadingViewModel extends ChangeNotifier {
  final String dataId;

  late final ImageUrlRepository _imageRepository;
  late final NewsRepository _newsRepository;

  ReadingViewModel(this.dataId) {
    _imageRepository = const ImageUrlRepository();

    final httpClient = HttpClientProxyWithDisposableConnection();
    _newsRepository = NewsRepository(httpClient);

    _load();
  }

  late Future<News> _dataFuture;
  Future<News> get dataFuture => _dataFuture;

  void _load() => _dataFuture = _newsRepository.load(dataId);

  void reload() {
    _load();

    notifyListeners();
  }

  String loadImageUrl(String filename) => _imageRepository.loadNews(filename);

  Background loadFallbackImage() => BackgroundRandom.nextAsset();
}
