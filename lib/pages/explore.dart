import 'package:flutter/material.dart';

import '../constants/style.dart';
import '../models/latest_news.dart';
import '../utils/future_widget.dart';
import '../widgets/image_background_sinking_title_card.dart';
import '../widgets/load_state_changed_network_image.dart';
import '../widgets/no_network_image_background_sign.dart';
import '../widgets/responsive_margin.dart';
import '../widgets/segment_indicator_carousel.dart';
import 'latest_news.dart';
import 'latest_news_view_model.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final viewModel = PartLatestNewsSlideshowViewModel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _windowHeight = MediaQuery.sizeOf(context).height;
  }

  late final _textTheme = Theme.of(context).textTheme;

  static const _borderRadius = RoundedCorner.largeBorderRadius;

  double get _carouselHeight => _expectedCarouselHeight > _minCarouselHeight
      ? _expectedCarouselHeight
      : _minCarouselHeight;
  static const _minCarouselHeight = 400.0;
  double get _expectedCarouselHeight => _windowHeight / 3;
  late double _windowHeight;

  List<Widget> _buildCards(BuildContext context, List<LatestNews> newsList) {
    final items = <Widget>[];

    for (var i = 0; i < newsList.length; i++) {
      final news = newsList[i];
      final fallbackImage = viewModel.fallbackImages[i];

      final item = ImageBackgroundTitleCard(
        borderRadius: _borderRadius,
        title: news.title,
        backgroundImage: LoadStateChangedNetworkImage(
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
  Widget build(BuildContext context) => ListView(children: [
        ResponsiveMargin(
          margin:
              const ResponsiveEdgeInsets.only(applyTop: true, applyStart: true, applyEnd: true),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '最新资讯',
                style: _textTheme.headlineLarge,
              ),
              LimitedBox(
                maxHeight: 36,
                child: OutlinedButton.icon(
                  icon: Icon(Icons.read_more_rounded),
                  label: Text('更多'),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LatestNewsPage(),
                      )),
                ),
              ),
            ],
          ),
        ),
        ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) => FutureWidget(
            dataFuture: viewModel.slideshowFuture,
            uncompletedWidget: SegmentIndicatorCarousel(
              maxCarouselHeight: _carouselHeight,
              autoplay: false,
              children: List.generate(
                viewModel.slideshowCount,
                (_) => ImageBackgroundTitleCardSkeleton(
                  isLoading: true,
                  borderRadius: _borderRadius,
                ),
              ),
            ),
            dataBuilder: (context, data) => SegmentIndicatorCarousel(
              maxCarouselHeight: _carouselHeight,
              children: _buildCards(context, data),
            ),
            errorBuilder: (context, _) => SegmentIndicatorCarousel(
              maxCarouselHeight: _carouselHeight,
              showIndicator: false,
              autoplay: false,
              isInfiniteLoop: false,
              children: [
                NoNetworkImageBackgroundSign(
                  retry: viewModel.reload,
                  backgroundImageAssetName:
                      viewModel.fallbackImages[0].assetName,
                  borderRadius: _borderRadius,
                )
              ],
            ),
          ),
        ),
      ]);
}
