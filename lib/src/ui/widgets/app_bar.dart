import 'package:flutter/material.dart';

import '../core/responsive_margin.dart';
import '../core/themes/constants/dimension.dart' as dimension;
import '../core/themes/constants/spacing.dart' as spacing;

class AppBarWithActions extends AppBar {
  AppBarWithActions(
      {super.key,
      super.centerTitle = true,
      required super.title,
      required List<Widget> actions})
      : super(
          actions: actions
            ..setAll(actions.length - 1, [
              Padding(
                padding: EdgeInsetsDirectional.only(
                    end: spacing.Padding.increment * 1),
                child: actions.last,
              ),
            ]),
        );
}

class FlexibleSliverAppBar extends StatelessWidget {
  final String title;

  const FlexibleSliverAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final responsiveEdgeInsets = calculateResponsiveMarginValue(context);

    return SliverAppBar.large(
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          overflow: TextOverflow.fade,
        ),
        titlePadding: EdgeInsetsDirectional.only(
            start: dimension.SliverAppBar.startPadding,
            end: responsiveEdgeInsets,
            bottom: dimension.SliverAppBar.bottomPadding),
      ),
      floating: true,
      pinned: false,
    );
  }
}

class FlexibleSliverAppBarWithoutLeading extends StatelessWidget {
  final String title;

  const FlexibleSliverAppBarWithoutLeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final responsiveEdgeInsets = calculateResponsiveMarginValue(context);

    return SliverAppBar.large(
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          overflow: TextOverflow.fade,
        ),
        titlePadding: EdgeInsetsDirectional.only(
            start: responsiveEdgeInsets,
            end: responsiveEdgeInsets,
            bottom: dimension.SliverAppBar.bottomPadding),
      ),
      surfaceTintColor: Colors.transparent,
      floating: true,
      pinned: false,
    );
  }
}
