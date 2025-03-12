import 'package:flutter/material.dart';

import '../widgets/skeleton.dart';
import 'bottom_gradient_transparent_box.dart';
import 'scroll_parallax_image.dart';

class ImageBackgroundTitleCard extends StatelessWidget {
  final String title;
  final Widget backgroundImage;
  final bool scrollBackgroundParallax;
  final double borderRadius;

  const ImageBackgroundTitleCard(
      {super.key,
      required this.title,
      required this.backgroundImage,
      this.scrollBackgroundParallax = false,
      this.borderRadius = 0});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = textTheme.titleMedium?.copyWith(
      color: Colors.white,
    );

    return GradientTransparentBox(
      borderRadius: borderRadius,
      image: scrollBackgroundParallax
          ? ScrollParallaxImage(
              image: backgroundImage,
            )
          : backgroundImage,
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            title,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

class ImageBackgroundTitleCardSkeleton extends StatelessWidget {
  final bool isLoading;
  final double borderRadius;

  const ImageBackgroundTitleCardSkeleton(
      {super.key, required this.isLoading, this.borderRadius = 0});

  @override
  Widget build(BuildContext context) => Skeleton(
        playEffect: isLoading,
        child: GradientTransparentBox(
          borderRadius: borderRadius,
          image: ColoredBox(
            color: Colors.transparent,
          ),
        ),
      );
}
