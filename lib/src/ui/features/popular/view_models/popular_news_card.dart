import 'package:flutter/material.dart';

import '../../../../data/models/popular_news.dart';
import '../../../../data/repositories/popular_news.dart';
import '../../../../utils/http_client_proxy.dart';

abstract class PopularNewsViewModel extends ChangeNotifier {
  static const _dataCount = 10;
  int get dataCount => _dataCount;

  late final PopularNewsRepository _repository;

  Future<List<PopularNews>> Function(int count) get _loadDataFromRepository;

  PopularNewsViewModel() {
    final httpClient = HttpClientProxyWithDisposableConnection();
    _repository = PopularNewsRepository(httpClient);

    _load();
  }

  late Future<List<PopularNews>> dataFuture;

  void _load() => dataFuture = _loadDataFromRepository(_dataCount);

  void reload() {
    _load();

    notifyListeners();
  }
}

class TodayPopularNewsCardViewModel extends PopularNewsViewModel {
  TodayPopularNewsCardViewModel._();

  factory TodayPopularNewsCardViewModel() => _instance;

  static final _instance = TodayPopularNewsCardViewModel._();

  @override
  Future<List<PopularNews>> Function(int count) get _loadDataFromRepository =>
      _repository.loadTodayWithCache;
}

class ThisWeekPopularNewsCardViewModel extends PopularNewsViewModel {
  ThisWeekPopularNewsCardViewModel._();

  factory ThisWeekPopularNewsCardViewModel() => _instance;

  static final _instance = ThisWeekPopularNewsCardViewModel._();

  @override
  Future<List<PopularNews>> Function(int count) get _loadDataFromRepository =>
      _repository.loadThisWeekWithCache;
}
