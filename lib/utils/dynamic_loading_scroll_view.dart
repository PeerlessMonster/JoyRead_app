import 'package:extended_list/extended_list.dart';
import 'package:flutter/material.dart';

import 'dynamic_loading_data_notifier.dart';
import 'future_widget.dart';
import 'scrolling_deferred_loading_builder.dart';

class DynamicLoadingScrollView<T> extends StatelessWidget {
  final List<T> initialData;
  final Future<List<T>> Function(int pageOrder) loadData;
  final int pageSize;
  final int preloadDataCount;
  final int maxCachedPageCount;
  final Widget Function(
      BuildContext context,
      LastChildLayoutType Function(int index) lastChildLayoutTypeBuilder,
      Widget Function(BuildContext context, int index) childBuilder,
      int childCount) scrollViewBulder;
  final Widget uncompletedWidget;
  final Widget Function(BuildContext context, T data, int index) successBuilder;
  final Widget Function(BuildContext context, Object error) errorBuilder;
  final Widget loadingMoreWidget;
  final Widget noMoreWidget;

  DynamicLoadingScrollView(
      {super.key,
      required this.initialData,
      required this.loadData,
      required this.pageSize,
      this.preloadDataCount = 1,
      required this.maxCachedPageCount,
      required this.scrollViewBulder,
      required this.uncompletedWidget,
      required this.successBuilder,
      required this.errorBuilder,
      required this.loadingMoreWidget,
      required this.noMoreWidget})
      : assert(pageSize > 0, 'Size of page should be positive integer'),
        assert(preloadDataCount >= 1 && preloadDataCount <= pageSize,
            'Count of preload should be in the range of size of page'),
        assert(initialData.isNotEmpty, 'Initial data cannot be empty');

  late final dataNotifier = DynamicLoadingDataNotifier<T>(
      initialData, loadData, pageSize, maxCachedPageCount);

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: dataNotifier,
        builder: (context, _) => scrollViewBulder(
          context,
          _lastChildLayoutTypeBuilder,
          _childBuilder,
          dataNotifier.loadedDataCount + 1,
        ),
      );

  LastChildLayoutType _lastChildLayoutTypeBuilder(int index) =>
      index == dataNotifier.loadedDataCount
          ? LastChildLayoutType.foot
          : LastChildLayoutType.none;

  Widget _childBuilder(BuildContext context, int index) {
    if (index == dataNotifier.loadedDataCount) {
      return dataNotifier.noMoreData ? noMoreWidget : loadingMoreWidget;
    }

    final isRunningOut =
        index + preloadDataCount >= dataNotifier.loadedDataCount;
    if (!dataNotifier.noMoreData && isRunningOut) {
      dataNotifier.loadNextPage();
    }

    final data = dataNotifier.readCache(index);
    if (data != null) {
      return successBuilder(context, data, index);
    }

    return ScrollingDeferredLoadingBuilder(
      underwayBuilder: (context, _) => uncompletedWidget,
      idleBuilder: (context, _) => FutureWidget(
        dataFuture: dataNotifier.loadCurrentPage(index),
        uncompletedWidget: uncompletedWidget,
        dataBuilder: (context, data) => successBuilder(context, data, index),
        errorBuilder: (context, error) => errorBuilder(context, error),
      ),
    );
  }
}
