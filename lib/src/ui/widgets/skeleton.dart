import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

PaintingEffect _buildEffect(bool playAnimation) =>
    playAnimation ? const ShimmerEffect() : const SoldColorEffect();

class BoxSkeleton extends StatelessWidget {
  final bool playAnimation;
  final double borderRadius;

  const BoxSkeleton(
      {super.key, this.playAnimation = true, this.borderRadius = 0});

  @override
  Widget build(BuildContext context) => Skeletonizer.zone(
        effect: _buildEffect(playAnimation),
        child: Bone.square(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      );
}

class ChipSkeleton extends StatelessWidget {
  final Widget avatar;
  final int widthAsWordCount;
  final bool playAnimation;

  const ChipSkeleton(
      {super.key,
      required this.avatar,
      this.widthAsWordCount = 3,
      this.playAnimation = true})
      : assert(widthAsWordCount > 0,
            'Count of words as width should be positive integer');

  @override
  Widget build(BuildContext context) => Skeletonizer.zone(
        effect: _buildEffect(playAnimation),
        child: Chip(
          label: Bone.text(
            words: widthAsWordCount,
          ),
          avatar: Skeleton.shade(child: avatar),
        ),
      );
}

class MultiTextSkeleton extends StatelessWidget {
  final int heightAsLineCount;
  final bool playAnimation;

  const MultiTextSkeleton(
      {super.key, this.heightAsLineCount = 3, this.playAnimation = true})
      : assert(heightAsLineCount > 0,
            'Count of line as height should be positive integer');

  @override
  Widget build(BuildContext context) => Skeletonizer.zone(
        effect: _buildEffect(playAnimation),
        child: Bone.multiText(
          lines: heightAsLineCount,
        ),
      );
}
