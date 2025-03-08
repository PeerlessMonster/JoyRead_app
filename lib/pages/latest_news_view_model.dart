import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:intl/intl.dart';

import '../models/latest_news.dart';
import '../networks/image.dart';
import '../repositories/news.dart';
import '../widgets/shared/background.dart';

class PartLatestNewsSlideshowViewModel extends ChangeNotifier {
  static const _slideshowCount = 5;
  int get slideshowCount => _slideshowCount;

  final List<Background> fallbackImages;

  PartLatestNewsSlideshowViewModel()
      : fallbackImages = BackgroundRandom.nextDistinctAssets(_slideshowCount) {
    _load();
  }

  late Future<List<LatestNews>> slideshowFuture;

  void _load() {
    final client = RetryClient(http.Client());
    try {
      slideshowFuture =
          loadLatestNewsWithCache(client, pageSize: _slideshowCount);
    } finally {
      client.close();
    }
  }

  void reload() {
    _load();

    notifyListeners();
  }
}

class LatestNewsPageViewModel extends ChangeNotifier {
  static const _pageSize = 18;
  int get pageSize => _pageSize;

  static const _preloadDataCount = 6;
  int get preloadDataCount => _preloadDataCount;

  static const _maxCachedPageCount = 2;
  int get maxCachedPageCount => _maxCachedPageCount;

  Background get fallbackImage => BackgroundRandom.nextAsset();

  final client = RetryClient(http.Client());
  void closeHttpClient() => client.close();

  LatestNewsPageViewModel() {
    _loadFirstPage();
  }

  late Future<List<LatestNews>> firstPageFuture;

  void _loadFirstPage() =>
      firstPageFuture = loadLatestNews(client, pageSize: _pageSize);

  void reloadFirstPage() {
    _loadFirstPage();

    notifyListeners();
  }

  Future<List<LatestNews>> Function(int pageOrder) get loadMorePage =>
      (pageOrder) =>
          loadLatestNews(client, pageSize: pageSize, pageOrder: pageOrder);
}

extension Formatting on LatestNews {
  String get coverImageUrl => generateNewsImageUrl(coverImageFilename);

  static final _dateFormatter = DateFormat.yMd().add_jm();
  String get formattedPublishTime {
    final localTimeZoned = publishTime.toLocal();
    return _dateFormatter.format(localTimeZoned);
  }
}
