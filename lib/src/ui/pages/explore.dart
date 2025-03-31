import 'package:flutter/material.dart';

import '../core/responsive_margin.dart';
import '../features/latest/views/latest_news_slideshow.dart';
import '../features/latest/views/latest_screen.dart';
import '../widgets/display_network_notification_body.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DisplayNetworkNotificationBody(
      child: ListView(children: [
        ResponsiveMargin(
          margin: const ResponsiveEdgeInsets.only(
              enableTop: true, enableStart: true, enableEnd: true),
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
                        builder: (context) => LatestScreen(),
                      )),
                ),
              ),
            ],
          ),
        ),
        LatestNewsSlideshow(),
      ]),
    );
  }
}
