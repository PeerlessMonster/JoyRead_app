import 'package:flutter/material.dart';

import '../core/themes/constants/dimension.dart' as dimension;

class RigidSliverAppBar extends StatelessWidget {
  final Widget title;

  const RigidSliverAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) => SliverAppBar(
        title: title,
        floating: true,
      );
}

class FlexibleSliverAppBar extends StatelessWidget {
  final String title;

  const FlexibleSliverAppBar({super.key, required this.title});
  @override
  Widget build(BuildContext context) => SliverAppBar.large(
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            title,
            overflow: TextOverflow.fade,
          ),
          titlePadding: EdgeInsetsDirectional.only(
              start: dimension.SliverAppBar.startPadding,
              end: dimension.SliverAppBar.endPadding,
              bottom: dimension.SliverAppBar.bottomPadding),
        ),
        floating: true,
        pinned: false,
      );
}

class FlexibleSliverAppBarWithoutLeading extends StatelessWidget {
  final String title;

  const FlexibleSliverAppBarWithoutLeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) => SliverAppBar.large(
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            title,
            overflow: TextOverflow.fade,
          ),
          titlePadding: const EdgeInsetsDirectional.only(
              start: dimension.SliverAppBar.horizontalPaddingWithoutLeading,
              end: dimension.SliverAppBar.horizontalPaddingWithoutLeading,
              bottom: dimension.SliverAppBar.bottomPadding),
        ),
        surfaceTintColor: Colors.transparent,
        floating: true,
        pinned: false,
      );
}
