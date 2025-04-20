import 'package:extended_list/extended_list.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/latest_news.dart';
import '../../../../utils/breakpoint.dart';
import '../../../core/breakpoint_state.dart';
import '../../../core/shared/background.dart';
import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../core/themes/constants/style.dart';
import '../../../features/read/views/read_screen.dart';
import '../../../widgets/image_background_card.dart';
import '../../../widgets/ink_well_for_opaque_widget.dart';
import '../../../widgets/load_state_changed_network_image.dart';
import '../../../widgets/load_state_changed_scroll_view.dart';
import '../../../widgets/scrolling_parallax_image.dart';
import '../view_models/extensions.dart';

class MoreLatestNewsList extends StatefulWidget {
  final List<LatestNews> firstPage;
  final Future<List<LatestNews>> Function(int pageOrder) loadMorePage;
  final String Function(String filename) loadImageUrl;
  final Background Function() loadFallbackImage;
  final int pageSize;
  final int preloadDataCount;
  final int maxCachedPageCount;

  const MoreLatestNewsList(
      {super.key,
      required this.firstPage,
      required this.loadMorePage,
      required this.loadImageUrl,
      required this.loadFallbackImage,
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
    final fallbackImage = widget.loadFallbackImage();
    return Padding(
      padding: padding,
      child: InkWellForOpaqueWidget(
        inkWell: InkWell(
          borderRadius: BorderRadius.circular(_borderRadius),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadScreen(
                  dataId: data.id,
                  title: data.title,
                  publishTime: data.formattedPublishTime,
                ),
              )),
        ),
        child: ImageBackgroundCardWithSpaceBetweenTitleAndLabel(
          title: data.title,
          label: data.formattedPublishTime,
          backgroundImage: LoadStateChangedNetworkImage(
            imageUrl,
            fallbackImageAssetName: fallbackImage.assetName,
            showLoadingPlaceholder: false,
            showLoadFailedPlaceholder: false,
            displayNotificationWhenLoadFailed: true,
            completedBuilder: (context, completedWidget) =>
                ScrollingParallaxImage(
              image: completedWidget,
              aspectRatio: 4 / 3,
            ),
            foregroundColor: fallbackImage.foregroundColor,
          ),
          borderRadius: _borderRadius,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = BreakpointState.of(context);
    final crossAxisCount = switch (breakpoint) {
      Breakpoint.compact => 1,
      Breakpoint.medium || Breakpoint.expanded => 2,
      Breakpoint.large || Breakpoint.extraLarge => 3,
    };

    return SliverPadding(
      padding: EdgeInsets.only(top: _spacing),
      sliver: LoadStateChangedScrollView(
        firstPage: widget.firstPage,
        loadMorePage: widget.loadMorePage,
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
        uncompletedWidget: ImageBackgroundCardSkeleton(
          isLoading: true,
          borderRadius: _borderRadius,
        ),
        successBuilder: (context, data, index) =>
            _buildCard(data, index, crossAxisCount: crossAxisCount),
        errorWidget: ImageBackgroundCardSkeleton(
          isLoading: false,
          borderRadius: _borderRadius,
        ),
      ),
    );
  }
}
