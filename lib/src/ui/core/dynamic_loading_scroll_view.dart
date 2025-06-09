import 'package:extended_list/extended_list.dart';
import 'package:flutter/material.dart';

import 'dynamic_loading_data_change_notifier.dart';
import 'future_widget.dart';
import 'scrolling_deferred_loading_builder.dart';

/// A [ScrollView] wrapper providing dynamic loading.
///
/// According to different load states, child builds through [uncompletedWidget]
/// , [dataBuilder], or [errorBuilder].
///
/// If next page has not been loaded yet while scrolling to bottom, last child
/// builds through [loadingMoreWidget]. However if load failed, builds through
/// [loadMoreFailedBuilder]. While scrolling to last page, builds through
/// [noMoreWidget].
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
class DynamicLoadingScrollView<T> extends StatefulWidget {
  final List<T> firstPage;
  final Future<List<T>> Function(int pageOrder) loadMorePage;
  final int pageSize;
  final int preloadDataCount;
  final int maxCachedPageCount;
  final Widget Function(
      BuildContext context,
      LastChildLayoutType Function(int index)? lastChildLayoutTypeBuilder,
      Widget? Function(BuildContext context, int index) childBuilder,
      int childCount) scrollViewBuilder;
  final Widget uncompletedWidget;
  final Widget Function(BuildContext context, T data, int index) dataBuilder;
  final Widget Function(BuildContext context, Object error) errorBuilder;
  final Widget? loadingMoreWidget;
  final Widget Function(BuildContext context, void Function() reload)?
      loadMoreFailedBuilder;
  final Widget? noMoreWidget;

  const DynamicLoadingScrollView(
      {super.key,
      required this.firstPage,
      required this.loadMorePage,
      required this.pageSize,
      this.preloadDataCount = 1,
      this.maxCachedPageCount = 2,
      required this.scrollViewBuilder,
      required this.uncompletedWidget,
      required this.dataBuilder,
      required this.errorBuilder,
      this.loadingMoreWidget,
      this.loadMoreFailedBuilder,
      this.noMoreWidget})
      : assert(preloadDataCount >= 1 && preloadDataCount <= pageSize,
            'Count of preload should be in the range of size of page');

  @override
  State<DynamicLoadingScrollView<T>> createState() =>
      _DynamicLoadingScrollViewState<T>();
}

class _DynamicLoadingScrollViewState<T>
    extends State<DynamicLoadingScrollView<T>> {
  late final _changeNotifier = DynamicLoadingDataChangeNotifier<T>(
      widget.firstPage,
      widget.loadMorePage,
      widget.pageSize,
      widget.maxCachedPageCount);

  Widget? _buildLastChild(BuildContext context, int index) {
    if (_changeNotifier.loadMoreFailed) {
      return widget.loadMoreFailedBuilder == null
          ? null
          : widget.loadMoreFailedBuilder!(
              context, _changeNotifier.loadNextPage);
    }

    if (_changeNotifier.noMoreData) {
      return widget.noMoreWidget;
    }
    return widget.loadingMoreWidget;
  }

  LastChildLayoutType _buildLastChildLayoutType(int index) =>
      index == _changeNotifier.loadedDataCount
          ? LastChildLayoutType.foot
          : LastChildLayoutType.none;

  Widget? _buildChild(BuildContext context, int index) {
    if (index == _changeNotifier.loadedDataCount) {
      return _buildLastChild(context, index);
    }

    final isRunningOut =
        index + widget.preloadDataCount >= _changeNotifier.loadedDataCount;
    if (!_changeNotifier.noMoreData && isRunningOut) {
      _changeNotifier.loadNextPage();
    }

    final data = _changeNotifier.readCache(index);
    if (data != null) {
      return widget.dataBuilder(context, data, index);
    }

    return ScrollingDeferredLoadingBuilder(
      underwayBuilder: (context, _) => widget.uncompletedWidget,
      idleBuilder: (context, _) => FutureWidget(
        dataFuture: _changeNotifier.loadCurrentPage(index),
        uncompletedWidget: widget.uncompletedWidget,
        dataBuilder: (context, data) =>
            widget.dataBuilder(context, data, index),
        errorBuilder: (context, error) => widget.errorBuilder(context, error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _changeNotifier,
        builder: (context, _) => widget.scrollViewBuilder(
            context,
            _buildLastChildLayoutType,
            _buildChild,
            _changeNotifier.loadedDataCount + 1),
      );
}
