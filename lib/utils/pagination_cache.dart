class PaginationCache<T> {
  final int pageSize;
  final int maxCachedPageCount;

  PaginationCache(this.pageSize, this.maxCachedPageCount)
      : assert(pageSize > 0, 'Size of page should be positive integer'),
        assert(maxCachedPageCount > 0,
            'Max count of cached page should be positive integer');

  final _cache = <int, List<T>>{};

  bool get isFull => _cache.length >= maxCachedPageCount;

  bool isExisted(int pageOrder) => _cache.containsKey(pageOrder);

  T? read(int pageOrder, int indexInPage) => _cache[pageOrder]?[indexInPage];

  void writeOnePage(int pageOrder, List<T> data) {
    if (isFull) {
      _removeFarPage(pageOrder);
    }
    _cache[pageOrder] = data;
  }

  void _removeFarPage(int pageOrder) => _cache.removeWhere((key, _) =>
      key <= pageOrder - maxCachedPageCount ||
      key >= pageOrder + maxCachedPageCount);
}
