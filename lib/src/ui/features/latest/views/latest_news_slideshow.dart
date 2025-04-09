import 'package:flutter/material.dart';

import '../../../../data/models/latest_news.dart';
import '../../../core/future_widget.dart';
import '../../../core/themes/constants/style.dart';
import '../../../widgets/image_background_card.dart';
import '../../../widgets/ink_well_for_opaque_widget.dart';
import '../../../widgets/load_state_changed_network_image.dart';
import '../../../widgets/network_error_image_background_sign.dart';
import '../../../widgets/segment_indicator_carousel.dart';
import '../../read/views/read_screen.dart';
import '../view_models/extensions.dart';
import '../view_models/latest_news_view_model.dart';

class LatestNewsSlideshow extends StatefulWidget {
  const LatestNewsSlideshow({super.key});

  @override
  State<LatestNewsSlideshow> createState() => _LatestNewsSlideshowState();
}

class _LatestNewsSlideshowState extends State<LatestNewsSlideshow> {
  final _viewModel = LatestNewsViewModel();

  static const _cardHeight = 400.0;

  static const _borderRadius = RoundedCorner.largeBorderRadius;

  List<Widget> _buildCards(BuildContext context, List<LatestNews> dataList) {
    final items = <Widget>[];

    for (var i = 0; i < dataList.length; i++) {
      final data = dataList[i];

      final imageUrl = _viewModel.loadImageUrl(data.coverImageFilename);
      final fallbackImage = _viewModel.fallbackImages[i];

      final item = InkWellForOpaqueWidget(
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
        child: ImageBackgroundCardWithSinkingTitle(
          borderRadius: _borderRadius,
          title: data.title,
          backgroundImage: LoadStateChangedNetworkImage(
            imageUrl,
            fallbackImageAssetName: fallbackImage.assetName,
            showLoadFailedPlaceholder: false,
            displayNotificationWhenLoadFailed: true,
            foregroundColor: fallbackImage.foregroundColor,
          ),
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
          dataFuture: _viewModel.dataFuture,
          uncompletedWidget: SegmentIndicatorCarousel(
            childHeight: _cardHeight,
            autoplay: false,
            children: List.generate(
              _viewModel.dataCount,
              (_) => ImageBackgroundCardSkeleton(
                isLoading: true,
                borderRadius: _borderRadius,
              ),
            ),
          ),
          dataBuilder: (context, data) => SegmentIndicatorCarousel(
            childHeight: _cardHeight,
            children: _buildCards(context, data),
          ),
          errorBuilder: (context, _) => SegmentIndicatorCarousel(
            childHeight: _cardHeight,
            showIndicator: false,
            autoplay: false,
            children: List.generate(
              3,
              (index) => NetworkErrorImageBackgroundSign(
                retry: _viewModel.reload,
                backgroundImageAssetName:
                    _viewModel.fallbackImages[index].assetName,
                borderRadius: _borderRadius,
              ),
            ),
          ),
        ),
      );
}
