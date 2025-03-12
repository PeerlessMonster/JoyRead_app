import 'package:extended_list/extended_list.dart';
import 'package:flutter/material.dart';

import 'dynamic_loading_data_notifier.dart';
import 'future_widget.dart';
import 'scrolling_deferred_loading_builder.dart';

/// A [ScrollView] wrapper providing dynamic loading.
///
/// Customize a [ExtendedSliverGrid] in [scrollViewBuilder]:
/// ```dart
/// DynamicLoadingScrollView(
///   ...
///   scrollViewBuilder:
///       (context, lastChildLayoutTypeBuilder, childBuilder, childCount) =>
///           ExtendedSliverGrid(
///       delegate: SliverChildBuilderDelegate(
///         childBuilder,
///         childCount: childCount,
///       ),
///       gridDelegate: ...,
///       extendedListDelegate: ExtendedListDelegate(
///         lastChildLayoutTypeBuilder: lastChildLayoutTypeBuilder,
///       ),
///     ),
///   ),
///   ...
/// )
/// ```
///
/// According to different load states, child builds through [uncompletedWidget]
/// , [successBuilder], or [errorBuilder].
///
/// If next page has not been loaded yet while scrolling to bottom, last child
/// builds through [loadingMoreWidget]. However while scrolling to last page,
/// builds through [noMoreWidget].
class DynamicLoadingScrollView<T> extends StatelessWidget {
  final List<T> initialData;
  final Future<List<T>> Function(int pageOrder) loadData;
  final int pageSize;
  final int preloadDataCount;
  final int maxCachedPageCount;
  final Widget Function(
      BuildContext context,
      LastChildLayoutType Function(int index) lastChildLayoutTypeBuilder,
      Widget? Function(BuildContext context, int index) childBuilder,
      int childCount) scrollViewBuilder;
  final Widget uncompletedWidget;
  final Widget Function(BuildContext context, T data, int index) successBuilder;
  final Widget Function(BuildContext context, Object error) errorBuilder;
  final Widget? loadingMoreWidget;
  final Widget? noMoreWidget;

  DynamicLoadingScrollView(
      {super.key,
      required this.initialData,
      required this.loadData,
      required this.pageSize,
      this.preloadDataCount = 1,
      this.maxCachedPageCount = 2,
      required this.scrollViewBuilder,
      required this.uncompletedWidget,
      required this.successBuilder,
      required this.errorBuilder,
      this.loadingMoreWidget,
      this.noMoreWidget})
      : assert(preloadDataCount >= 1 && preloadDataCount <= pageSize,
            'Count of preload should be in the range of size of page'),
        assert(initialData.isNotEmpty, 'List of initial data cannot be empty');

  late final _dataNotifier = DynamicLoadingDataNotifier<T>(
      initialData, loadData, pageSize, maxCachedPageCount);

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _dataNotifier,
        builder: (context, _) => scrollViewBuilder(
            context,
            _lastChildLayoutTypeBuilder,
            _childBuilder,
            _dataNotifier.loadedDataCount + 1),
      );

  LastChildLayoutType _lastChildLayoutTypeBuilder(int index) =>
      index == _dataNotifier.loadedDataCount
          ? LastChildLayoutType.foot
          : LastChildLayoutType.none;

  Widget? _childBuilder(BuildContext context, int index) {
    if (index == _dataNotifier.loadedDataCount) {
      return _dataNotifier.noMoreData ? noMoreWidget : loadingMoreWidget;
    }

    final isRunningOut =
        index + preloadDataCount >= _dataNotifier.loadedDataCount;
    if (!_dataNotifier.noMoreData && isRunningOut) {
      _dataNotifier.loadNextPage();
    }

    final data = _dataNotifier.readCache(index);
    if (data != null) {
      return successBuilder(context, data, index);
    }

    return ScrollingDeferredLoadingBuilder(
      underwayBuilder: (context, _) => uncompletedWidget,
      idleBuilder: (context, _) => FutureWidget(
        dataFuture: _dataNotifier.loadCurrentPage(index),
        uncompletedWidget: uncompletedWidget,
        dataBuilder: (context, data) => successBuilder(context, data, index),
        errorBuilder: (context, error) => errorBuilder(context, error),
      ),
    );
  }
}
