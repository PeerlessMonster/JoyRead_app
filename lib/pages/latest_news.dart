import 'package:extended_list/extended_list.dart';
import 'package:flutter/material.dart';

import '../constants/breakpoint.dart';
import '../constants/layout.dart';
import '../constants/style.dart';
import '../models/latest_news.dart';
import '../utils/adaptive_state.dart';
import '../utils/dynamic_loading_scroll_view.dart';
import '../utils/future_widget.dart';
import '../widgets/image_background_space_between_title_subtitle_card.dart';
import '../widgets/load_state_changed_network_image.dart';
import '../widgets/page_back_app_bar.dart';
import '../widgets/shared/sign.dart';
import 'latest_news_view_model.dart';

class LatestNewsPage extends StatefulWidget {
  const LatestNewsPage({super.key});

  @override
  State<LatestNewsPage> createState() => _LatestNewsPageState();
}

class _LatestNewsPageState extends State<LatestNewsPage>
    with AdaptiveState<LatestNewsPage> {
  late final viewModel = LatestNewsPageViewModel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentCrossAxisCount = switch (breakpoint) {
      Breakpoint.compact => 1,
      Breakpoint.medium || Breakpoint.expanded => 2,
      Breakpoint.large || Breakpoint.extraLarge => 3,
    };
    if (crossAxisCount != currentCrossAxisCount) {
      crossAxisCount = currentCrossAxisCount;
    }
  }

  var crossAxisCount = 1;

  late final colorScheme = Theme.of(context).colorScheme;

  static const _borderRadius = RoundedCorner.smallBorderRadius;

  static const _spacing = Spacing.paddingIncrement * 1;

  Widget _buildCard(BuildContext context, LatestNews data, int index) {
    late final EdgeInsetsGeometry padding;
    switch (crossAxisCount) {
      case 1:
        padding = EdgeInsets.symmetric(horizontal: _spacing);
      case > 1:
        final crossAxisOrder = index % crossAxisCount;
        if (crossAxisOrder == 0) {
          padding = EdgeInsetsDirectional.only(start: _spacing);
        } else if (crossAxisOrder == crossAxisCount - 1) {
          padding = EdgeInsetsDirectional.only(end: _spacing);
        } else {
          padding = EdgeInsets.zero;
        }
      default:
        throw RangeError.range(crossAxisCount, 1, null, 'crossAxisCount',
            'CrossAxisCount should be positive integer');
    }

    final fallbackImage = viewModel.fallbackImage;
    return Padding(
      padding: padding,
      child: ImageBackgroundTitleSubtitleCard(
        title: data.title,
        label: data.formattedPublishTime,
        backgroundImage: LoadStateChangedNetworkImage(
          data.coverImageUrl,
          fallbackImageAssetName: fallbackImage.assetName,
          color: fallbackImage.onBackground,
        ),
        scrollBackgroundParallax: true,
        borderRadius: _borderRadius,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => FutureWidget(
          dataFuture: viewModel.firstPageFuture,
          uncompletedWidget: Scaffold(
            appBar: PageBackAppBar.build(
              context,
              title: '最新资讯',
            ),
            body: Center(
              child: LoadingSign(),
            ),
          ),
          dataBuilder: (context, data) => Scaffold(
            body: CustomScrollView(slivers: [
              PageBackSliverAppBar(
                title: '最新资讯',
              ),
              DynamicLoadingScrollView(
                initialData: data,
                loadData: viewModel.loadMorePage,
                pageSize: viewModel.pageSize,
                preloadDataCount: viewModel.preloadDataCount,
                maxCachedPageCount: viewModel.maxCachedPageCount,
                scrollViewBulder: (context, lastChildLayoutTypeBuilder,
                        childBuilder, childCount) =>
                    ExtendedSliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childBuilder,
                    childCount: childCount,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: _spacing,
                    crossAxisSpacing: _spacing,
                    childAspectRatio: 2.88,
                  ),
                  extendedListDelegate: ExtendedListDelegate(
                    lastChildLayoutTypeBuilder: lastChildLayoutTypeBuilder,
                  ),
                ),
                uncompletedWidget: ImageBackgroundTitleLabelCardSkeleton(
                  isLoading: true,
                  borderRadius: _borderRadius,
                ),
                successBuilder: _buildCard,
                errorBuilder: (context, _) =>
                    ImageBackgroundTitleLabelCardSkeleton(
                  isLoading: false,
                  borderRadius: _borderRadius,
                ),
                loadingMoreWidget: Padding(
                  padding: EdgeInsets.only(top: _spacing),
                  child: LinearProgressIndicator(),
                ),
                noMoreWidget: Padding(
                  padding: EdgeInsets.only(top: _spacing),
                  child: SizedBox(
                    height: 50,
                    child: ColoredBox(
                      color: colorScheme.surfaceContainer,
                      child: Center(
                        child: Text('已经到底啦'),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          errorBuilder: (context, _) => Scaffold(
            appBar: PageBackAppBar.build(
              context,
              title: '最新资讯',
            ),
            body: Center(
              child: NoNetworkSign(
                retry: viewModel.reloadFirstPage,
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    viewModel.closeHttpClient();

    super.dispose();
  }
}
