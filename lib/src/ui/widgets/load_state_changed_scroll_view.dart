import 'package:extended_list/extended_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../core/dynamic_loading_scroll_view.dart';
import '../core/network_notification.dart';
import '../core/themes/constants/spacing.dart' as spacing;

class LoadStateChangedScrollView<T> extends StatelessWidget {
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
  final Widget Function(BuildContext context, T data, int index) successBuilder;
  final Widget errorWidget;
  static const _padding = spacing.Padding.increment * 1;

  const LoadStateChangedScrollView(
      {super.key,
      required this.firstPage,
      required this.loadMorePage,
      required this.pageSize,
      this.preloadDataCount = 1,
      this.maxCachedPageCount = 2,
      required this.scrollViewBuilder,
      required this.uncompletedWidget,
      required this.successBuilder,
      required this.errorWidget});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DynamicLoadingScrollView(
      firstPage: firstPage,
      loadMorePage: loadMorePage,
      pageSize: pageSize,
      scrollViewBuilder: scrollViewBuilder,
      uncompletedWidget: uncompletedWidget,
      dataBuilder: (context, data, index) {
        SchedulerBinding.instance.addPostFrameCallback(
            (timestamp) => NetworkNotification.restored().dispatch(context));

        return successBuilder(context, data, index);
      },
      errorBuilder: (context, _) {
        SchedulerBinding.instance.addPostFrameCallback(
            (timestamp) => NetworkNotification.error().dispatch(context));

        return errorWidget;
      },
      loadingMoreWidget: Padding(
        padding: EdgeInsets.only(top: _padding),
        child: LinearProgressIndicator(),
      ),
      loadMoreFailedBuilder: (context, reload) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.Padding.increment * 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: spacing.Padding.targetSpacing,
          children: [
            Text('Failed to load next page.'),
            OutlinedButton.icon(
              icon: Icon(Icons.refresh_rounded),
              label: Text('Retry'),
              onPressed: reload,
            ),
          ],
        ),
      ),
      noMoreWidget: Padding(
        padding: EdgeInsets.only(top: _padding),
        child: SizedBox(
          height: 50,
          child: ColoredBox(
            color: colorScheme.surfaceContainer,
            child: Center(
              child: Text('已经到底啦~'),
            ),
          ),
        ),
      ),
    );
  }
}
