import 'package:extended_list/extended_list.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/latest_news.dart';
import '../../../../utils/breakpoint.dart';
import '../../../core/breakpoint_state.dart';
import '../../../core/dynamic_loading_scroll_view.dart';
import '../../../core/shared/background.dart';
import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../core/themes/constants/style.dart';
import '../../../features/read/views/read_screen.dart';
import '../../../widgets/image_background_space_between_title_subtitle_card.dart';
import '../../../widgets/load_state_changed_network_image.dart';
import '../view_models/extensions.dart';

class MoreLatestNewsList extends StatefulWidget {
  final List<LatestNews> firstPage;
  final Future<List<LatestNews>> Function(int pageOrder) loadMorePage;
  final String Function(String filename) loadImageUrl;
  final Background fallbackImage;
  final int pageSize;
  final int preloadDataCount;
  final int maxCachedPageCount;

  const MoreLatestNewsList(
      {super.key,
      required this.firstPage,
      required this.loadMorePage,
      required this.loadImageUrl,
      required this.fallbackImage,
      required this.pageSize,
      required this.preloadDataCount,
      required this.maxCachedPageCount});

  @override
  State<StatefulWidget> createState() => _MoreLatestNewsListState();
}

class _MoreLatestNewsListState extends State<MoreLatestNewsList> {
  static const _spacing = spacing.Padding.increment * 1;

  static const _borderRadius = RoundedCorner.smallBorderRadius;

  Widget _buildCard(LatestNews data, int index, {required int crossAxisCount}) {
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

    final imageUrl = widget.loadImageUrl(data.coverImageFilename);
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadScreen(
                dataId: data.id,
                title: data.title,
                publishTime: data.formattedPublishTime,
              ),
            )),
        child: ImageBackgroundTitleSubtitleCard(
          title: data.title,
          label: data.formattedPublishTime,
          backgroundImage: LoadStateChangedNetworkImageWithPlaceholder(
            imageUrl,
            fallbackImageAssetName: widget.fallbackImage.assetName,
            color: widget.fallbackImage.onBackground,
          ),
          scrollBackgroundParallax: true,
          borderRadius: _borderRadius,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final breakpoint = BreakpointState.of(context);
    final crossAxisCount = switch (breakpoint) {
      Breakpoint.compact => 1,
      Breakpoint.medium || Breakpoint.expanded => 2,
      Breakpoint.large || Breakpoint.extraLarge => 3,
    };

    return DynamicLoadingScrollView(
      initialData: widget.firstPage,
      loadData: widget.loadMorePage,
      pageSize: widget.pageSize,
      preloadDataCount: widget.preloadDataCount,
      maxCachedPageCount: widget.maxCachedPageCount,
      scrollViewBuilder:
          (context, lastChildLayoutTypeBuilder, childBuilder, childCount) =>
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
      successBuilder: (context, data, index) =>
          _buildCard(data, index, crossAxisCount: crossAxisCount),
      errorBuilder: (context, _) => ImageBackgroundTitleLabelCardSkeleton(
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
    );
  }
}
