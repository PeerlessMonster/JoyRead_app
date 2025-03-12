import 'package:flutter/material.dart';

import '../../utils/pagination_cache.dart';
import 'dynamic_loading_scroll_view.dart';

/// View model of [DynamicLoadingScrollView].
///
/// Imported by [DynamicLoadingScrollView], no need to construct manually.
class DynamicLoadingDataNotifier<T> extends ChangeNotifier {
  final int pageSize;

  int _calculatePageOrder(int index) => index ~/ pageSize;

  int _calculateIndexInPage(int index) => index % pageSize;

  late bool noMoreData;

  DynamicLoadingDataNotifier(List<T> initialData, this.loadData, this.pageSize,
      [int maxCachedPageCount = 2]) {
    assert(pageSize > 0, 'Size of page should be positive integer');

    _cache = PaginationCache<T>(pageSize, maxCachedPageCount);
    _cache.writeOnePage(0, initialData);

    loadedDataCount = initialData.length;
    noMoreData = initialData.length < pageSize;
  }

  late final PaginationCache _cache;

  T? readCache(int index) {
    final pageOrder = _calculatePageOrder(index);
    final indexInPage = _calculateIndexInPage(index);
    return _cache.read(pageOrder, indexInPage);
  }

  late int loadedDataCount;
  final Future<List<T>> Function(int pageOrder) loadData;

  Future<T> loadCurrentPage(int index) async {
    final indexInPage = _calculateIndexInPage(index);
    final pageOrder = _calculatePageOrder(index);
    if (_cache.isExisted(pageOrder)) {
      return _cache.read(pageOrder, indexInPage);
    }

    final data = await loadData(pageOrder);

    _cache.writeOnePage(pageOrder, data);

    return data[indexInPage];
  }

  Future<void> loadNextPage() async {
    final nextPageOrder = _calculatePageOrder(loadedDataCount);
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
