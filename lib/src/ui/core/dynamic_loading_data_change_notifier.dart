import 'package:flutter/material.dart';

import '../../utils/pagination_cache.dart';
import 'dynamic_loading_scroll_view.dart';

/// View Model of [DynamicLoadingScrollView].
///
/// Imported by [DynamicLoadingScrollView], no need to construct manually.
class DynamicLoadingDataChangeNotifier<T> extends ChangeNotifier {
  final int pageSize;

  int _calculatePageOrder(int index) => index ~/ pageSize;

  int _calculateIndexInPage(int index) => index % pageSize;

  late bool _noMoreData;
  bool get noMoreData => _noMoreData;

  var _loadMoreFailed = false;
  bool get loadMoreFailed => _loadMoreFailed;

  DynamicLoadingDataChangeNotifier(
      List<T> firstPage, this.loadMorePage, this.pageSize,
      [int maxCachedPageCount = 2]) {
    assert(firstPage.isNotEmpty, 'List of initial data cannot be empty');
    assert(pageSize > 0, 'Size of page should be positive integer');

    _cache = PaginationCache<T>(pageSize, maxCachedPageCount);
    _cache.writeOnePage(0, firstPage);

    _loadedDataCount = firstPage.length;
    _noMoreData = firstPage.length < pageSize;
  }

  late final PaginationCache _cache;

  T? readCache(int index) {
    final pageOrder = _calculatePageOrder(index);
    final indexInPage = _calculateIndexInPage(index);
    return _cache.read(pageOrder, indexInPage);
  }

  late int _loadedDataCount;
  int get loadedDataCount => _loadedDataCount;

  final Future<List<T>> Function(int pageOrder) loadMorePage;

  Future<T> loadCurrentPage(int index) async {
    final indexInPage = _calculateIndexInPage(index);
    final pageOrder = _calculatePageOrder(index);
    if (_cache.containsPage(pageOrder)) {
      return _cache.read(pageOrder, indexInPage);
    }

    final data = await loadMorePage(pageOrder);

    _cache.writeOnePage(pageOrder, data);

    return data[indexInPage];
  }

  Future<void> loadNextPage() async {
    final nextPageOrder = _calculatePageOrder(_loadedDataCount);
    if (_cache.containsPage(nextPageOrder)) {
      return;
    }

    late final List<T> data;
    try {
      data = await loadMorePage(nextPageOrder);

      if (_loadMoreFailed) {
        _loadMoreFailed = false;

        notifyListeners();
      }
    } catch (_) {
      if (!_loadMoreFailed) {
        _loadMoreFailed = true;

        notifyListeners();
      }
      return;
    }

    _cache.writeOnePage(nextPageOrder, data);

    final hasMoreData =
        nextPageOrder * pageSize + data.length > _loadedDataCount;
    if (hasMoreData) {
      _loadedDataCount += data.length;

      notifyListeners();
    }

    if (data.length < pageSize) {
      _noMoreData = true;

      notifyListeners();
    }
    return;
  }
}
