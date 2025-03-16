import 'package:flutter/material.dart';

import '../core/responsive_margin.dart';
import '../features/latest/views/latest_news_slideshow.dart';
import '../features/latest/views/news_screen.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  static const _minSlideshowHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final screenHeight = MediaQuery.sizeOf(context).height;
    final slideshowHeight = screenHeight / 3;

    return ListView(children: [
      ResponsiveMargin(
        margin: const ResponsiveEdgeInsets.only(
            applyTop: true, applyStart: true, applyEnd: true),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '最新资讯',
              style: textTheme.headlineLarge,
            ),
            SizedBox(
              height: 36,
              child: OutlinedButton.icon(
                icon: Icon(Icons.read_more_rounded),
                label: Text('更多'),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsScreen(),
                    )),
              ),
            ),
          ],
        ),
      ),
      LatestNewsSlideshow(
        maxHeight: slideshowHeight > _minSlideshowHeight
            ? slideshowHeight
            : _minSlideshowHeight,
      ),
    ]);
  }
}
