import 'package:flutter/material.dart';

import '../constants/style.dart';
import '../models/latest_news.dart';
import '../networks/image.dart';
import '../repositories/news.dart';
import '../utils/future_widget.dart';
import '../widgets/load_state_changed_network_image.dart';
import '../widgets/no_network_placeholder.dart';
import '../widgets/responsive_margin.dart';
import '../widgets/segment_indicator_carousel.dart';
import '../widgets/shared/random_background.dart';
import '../widgets/sinking_title_image_background_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final _assetImages =
      BackgroundRandom.nextDistinctAssets(_latestNewsCount);

  static const _latestNewsCount = 5;
  late final Future<List<LatestNews>> _latestNews;
  void _loadData() {
    _latestNews = loadLatestNews(_latestNewsCount);
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  late final _textTheme = Theme.of(context).textTheme;

  static const _borderRadius = RoundedCorner.largeBorderRadius;

  double get _carouselHeight => _expectedCarouselHeight > _minCarouselHeight
      ? _expectedCarouselHeight
      : _minCarouselHeight;
  static const _minCarouselHeight = 400.0;
  double get _expectedCarouselHeight => _windowHeight / 3;
  late double _windowHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _windowHeight = MediaQuery.sizeOf(context).height;
  }

  List<Widget> _buildCards(List<LatestNews> newsList) {
    final children = <Widget>[];

    for (var i = 0; i < newsList.length; i++) {
      final news = newsList[i];

      final coverImageUrl = generateNewsImageUrl(news.coverImgFilename);

      final child = TitleImageBackgroundCard(
        backgroundImage: LoadStateChangedNetworkImage(
          url: coverImageUrl,
          fallbackAssetName: _assetImages[i].assetName,
          color: _assetImages[i].onBackground,
          borderRadius: _borderRadius,
        ),
        text: news.title,
        borderRadius: _borderRadius,
      );
      children.add(child);
    }
    return children;
  }

  @override
  Widget build(BuildContext context) => ListView(children: [
        ResponsiveMargin(
          margin:
              ResponsiveEdgeInsets.only(applyHorizontal: true, applyTop: true),
          child: Text(
            '最新资讯',
            style: _textTheme.headlineLarge,
          ),
        ),
        FutureWidget(
          data: _latestNews,
          uncompletedWidget: SegmentIndicatorCarousel(
            maxImageHeight: _carouselHeight,
            autoplay: false,
            children: List.generate(
              _latestNewsCount,
              (_) => TitleImageBackgroundCardSkeleton(
                borderRadius: _borderRadius,
              ),
            ),
          ),
          successBuilder: (context, data) => SegmentIndicatorCarousel(
            maxImageHeight: _carouselHeight,
            children: _buildCards(data),
          ),
          errorBuilder: (context, _) => SegmentIndicatorCarousel(
            maxImageHeight: _carouselHeight,
            showIndicator: false,
            autoplay: false,
            isInfiniteLoop: false,
            children: [
              NoNetworkPlaceholder(
                retry: () => setState(() {
                  _loadData();
                }),
                backgroundImageAssetName: _assetImages[0].assetName,
                borderRadius: _borderRadius,
              )
            ],
          ),
        ),
      ]);
}
