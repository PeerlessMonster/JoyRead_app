import 'package:flutter/material.dart';

import 'pagination_cache.dart';

class DynamicLoadingDataNotifier<T> extends ChangeNotifier {
  final int pageSize;

  int _caluculatePageOrder(int index) => index ~/ pageSize;

  int _calculateIndexInPage(int index) => index % pageSize;

  late bool noMoreData;

  DynamicLoadingDataNotifier(List<T> initialData, this.loadData, this.pageSize,
      int maxCachedPageCount) {
    _cache = PaginationCache<T>(pageSize, maxCachedPageCount);
    _cache.writeOnePage(0, initialData);

    loadedDataCount = initialData.length;
    noMoreData = initialData.length < pageSize;
  }

  late final PaginationCache _cache;

  T? readCache(int index) {
    final pageOrder = _caluculatePageOrder(index);
    final indexInPage = _calculateIndexInPage(index);
    return _cache.read(pageOrder, indexInPage);
  }

  late int loadedDataCount;
  final Future<List<T>> Function(int pageOrder) loadData;

  Future<T> loadCurrentPage(int index) async {
    final indexInPage = _calculateIndexInPage(index);
    final pageOrder = _caluculatePageOrder(index);
    if (_cache.isExisted(pageOrder)) {
      return _cache.read(pageOrder, indexInPage);
    }

    final data = await loadData(pageOrder);

    _cache.writeOnePage(pageOrder, data);

    return data[indexInPage];
  }

  Future<void> loadNextPage() async {
    final nextPageOrder = _caluculatePageOrder(loadedDataCount);
    if (_cache.isExisted(nextPageOrder)) {
      return;
    }

    final data = await loadData(nextPageOrder);

    _cache.writeOnePage(nextPageOrder, data);

    final hasMoreData =
        nextPageOrder * pageSize + data.length > loadedDataCount;
    if (hasMoreData) {
      loadedDataCount += data.length;

      notifyListeners();
    }

    if (data.length < pageSize) {
      noMoreData = true;

      notifyListeners();
    }
    return;
  }
}
