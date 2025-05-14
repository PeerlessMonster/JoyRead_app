import 'package:flutter/material.dart';

import '../../../../data/models/news_title.dart';
import '../../../../data/repositories/popular_news.dart';
import '../../../../utils/http_client_proxy.dart';

abstract class PopularNewsViewModel extends ChangeNotifier {
  static const _dataCount = 10;
  int get dataCount => _dataCount;

  late final PopularNewsRepository _repository;

  Future<List<NewsTitle>> Function(int count) get _loadDataFromRepository;

  PopularNewsViewModel() {
    final httpClient = HttpClientProxyWithDisposableConnection();
    _repository = PopularNewsRepository(httpClient);

    _load();
  }

  late Future<List<NewsTitle>> dataFuture;

  void _load() => dataFuture = _loadDataFromRepository(_dataCount);

  void reload() {
    _load();

    notifyListeners();
  }
}

class TodayPopularNewsViewModel extends PopularNewsViewModel {
  TodayPopularNewsViewModel._();

  factory TodayPopularNewsViewModel() => _instance;

  static final _instance = TodayPopularNewsViewModel._();

  @override
  Future<List<NewsTitle>> Function(int count) get _loadDataFromRepository =>
      _repository.loadTodayWithCache;
}

class ThisWeekPopularNewsViewModel extends PopularNewsViewModel {
  ThisWeekPopularNewsViewModel._();

  factory ThisWeekPopularNewsViewModel() => _instance;

  static final _instance = ThisWeekPopularNewsViewModel._();

  @override
  Future<List<NewsTitle>> Function(int count) get _loadDataFromRepository =>
      _repository.loadThisWeekWithCache;
}
