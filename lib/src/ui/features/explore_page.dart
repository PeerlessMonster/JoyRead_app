import 'package:flutter/material.dart';

import '../../utils/breakpoint.dart';
import '../core/breakpoint_state.dart';
import '../core/max_width_box.dart';
import '../core/responsive_margin.dart';
import '../core/themes/constants/spacing.dart' as spacing;
import '../widgets/button.dart';
import '../widgets/sliding_segmented_control.dart';
import 'latest/views/latest_news_slideshow.dart';
import 'latest/views/more_news_screen.dart';
import 'popular/views/popular_news_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  var currentSegment = Sort.day;

  static const _maxBreakpoint = Breakpoint.large;
  static const _spacing = spacing.Padding.increment * 2;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final breakpoint = BreakpointState.of(context);
    final doubleCard = breakpoint >= Breakpoint.expanded;

    return ListView(children: [
      // feature: Latest
      ResponsiveMargin(
        margin: const ResponsiveEdgeInsets.only(
          enableStart: true,
          enableEnd: true,
          enableTop: true,
        ),
        child: MaxWidthBox.breakpoint(
          endpoint: _maxBreakpoint,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '最新资讯',
                style: textTheme.headlineLarge,
              ),
              SizedBox(
                height: 36,
                child: ElevatedRoundedRectangleIconButton(
                  icon: Icon(Icons.more_horiz_rounded),
                  label: Text('更多'),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MoreNewsScreen(),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: _spacing),
      LatestNewsSlideshow(),

      SizedBox(height: 64),

      // feature: Popular
      ResponsiveMargin(
        margin: const ResponsiveEdgeInsets.symmetric(enableHorizontal: true),
        child: MaxWidthBox.breakpoint(
          endpoint: _maxBreakpoint,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '时下热门',
                    style: textTheme.headlineLarge,
                  ),
                  Visibility(
                    visible: !doubleCard,
                    child: SlidingSegmentedControl(
                      segmentsText: {
                        Sort.day: Sort.day.title,
                        Sort.week: Sort.week.title,
                      },
                      selectedSegment: currentSegment,
                      onSegmentChanged: (selection) => setState(() {
                        currentSegment = selection;
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: _spacing),
              doubleCard
                  ? Center(
                      child: Row(
                        spacing: calculateResponsiveMarginValue(context),
                        children: Sort.values
                            .map((sort) => Expanded(
                                  flex: 1,
                                  child: PopularNewsCard(sort: sort),
                                ))
                            .toList(),
                      ),
                    )
                  : PopularNewsCard(
                      sort: currentSegment,
                      showHeader: false,
                    ),
            ],
          ),
        ),
      ),

      SizedBox(height: spacing.Padding.increment * 9),
    ]);
  }
}
