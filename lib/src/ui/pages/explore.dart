import 'package:flutter/material.dart';

import '../core/responsive_margin.dart';
import '../features/latest/views/latest_news_slideshow.dart';
import 'latest.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final _textTheme = Theme.of(context).textTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _windowHeight = MediaQuery.sizeOf(context).height;
  }

  late double _windowHeight;

  double get _expectedSlideshowHeight => _windowHeight / 3;
  static const _minSlideshowHeight = 400.0;

  double get slideshowHeight => _expectedSlideshowHeight > _minSlideshowHeight
      ? _expectedSlideshowHeight
      : _minSlideshowHeight;

  @override
  Widget build(BuildContext context) => ListView(children: [
        ResponsiveMargin(
          margin: const ResponsiveEdgeInsets.only(
              applyTop: true, applyStart: true, applyEnd: true),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '最新资讯',
                style: _textTheme.headlineLarge,
              ),
              SizedBox(
                height: 36,
                child: OutlinedButton.icon(
                  icon: Icon(Icons.read_more_rounded),
                  label: Text('更多'),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LatestPage(),
                      )),
                ),
              ),
            ],
          ),
        ),
        LatestNewsSlideshow(
          maxHeight: slideshowHeight,
        ),
      ]);
}
