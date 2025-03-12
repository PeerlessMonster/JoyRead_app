import 'package:flutter/material.dart';

import '../../../../data/models/latest_news.dart';
import '../../../core/future_widget.dart';
import '../../../core/themes/constants/style.dart';
import '../../../widgets/image_background_sinking_title_card.dart';
import '../../../widgets/load_state_changed_network_image.dart';
import '../../../widgets/no_network_image_background_sign.dart';
import '../../../widgets/segment_indicator_carousel.dart';
import '../view_models/extensions.dart';
import '../view_models/latest_news_slideshow.dart';

class LatestNewsSlideshow extends StatelessWidget {
  final double maxHeight;
  static const _borderRadius = RoundedCorner.largeBorderRadius;

  LatestNewsSlideshow({super.key, required this.maxHeight});

  final _viewModel = LatestNewsSlideshowViewModel();

  List<Widget> _buildCards(BuildContext context, List<LatestNews> newsList) {
    final items = <Widget>[];

    for (var i = 0; i < newsList.length; i++) {
      final news = newsList[i];
      final fallbackImage = _viewModel.fallbackImages[i];

      final item = ImageBackgroundTitleCard(
        borderRadius: _borderRadius,
        title: news.title,
        backgroundImage: LoadStateChangedNetworkImageWithPlaceholder(
          news.coverImageUrl,
          fallbackImageAssetName: fallbackImage.assetName,
          color: fallbackImage.onBackground,
        ),
      );
      items.add(item);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => FutureWidget(
          dataFuture: _viewModel.slideshowFuture,
          uncompletedWidget: SegmentIndicatorCarousel(
            maxCarouselHeight: maxHeight,
            autoplay: false,
            children: List.generate(
              _viewModel.slideshowCount,
              (_) => ImageBackgroundTitleCardSkeleton(
                isLoading: true,
                borderRadius: _borderRadius,
              ),
            ),
          ),
          dataBuilder: (context, data) => SegmentIndicatorCarousel(
            maxCarouselHeight: maxHeight,
            children: _buildCards(context, data),
          ),
          errorBuilder: (context, _) => SegmentIndicatorCarousel(
            maxCarouselHeight: maxHeight,
            showIndicator: false,
            autoplay: false,
            isInfiniteLoop: false,
            children: [
              NoNetworkImageBackgroundSign(
                retry: _viewModel.reload,
                backgroundImageAssetName:
                    _viewModel.fallbackImages[0].assetName,
                borderRadius: _borderRadius,
              )
            ],
          ),
        ),
      );
}
