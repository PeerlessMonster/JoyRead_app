import 'package:flutter/material.dart';

class SizedSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SizedSliverPersistentHeaderDelegate(
      {required this.child, required this.height})
      : assert(height >= 0, 'Height should begin from 0');

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      SizedBox.expand(
        child: child,
      );

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SizedSliverPersistentHeaderDelegate oldDelegate) =>
      maxExtent != oldDelegate.maxExtent || minExtent != oldDelegate.minExtent;
}
