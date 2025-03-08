import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Skeleton extends StatelessWidget {
  final Widget child;
  final bool playEffect;

  const Skeleton({super.key, this.playEffect = true, required this.child});

  @override
  Widget build(BuildContext context) => Skeletonizer(
        enabled: true,
        effect: playEffect ? const ShimmerEffect() : const SoldColorEffect(),
        child: child,
      );
}
