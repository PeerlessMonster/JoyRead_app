import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'bottom_gradient_transparent_box.dart';

class TitleImageBackgroundCard extends StatelessWidget {
  final Widget backgroundImage;
  final String text;
  final double borderRadius;

  const TitleImageBackgroundCard(
      {super.key,
      required this.backgroundImage,
      required this.text,
      this.borderRadius = 0});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = textTheme.titleMedium?.copyWith(
      color: Colors.white,
    );

    return GradientTransparentBox(
      borderRadius: borderRadius,
      alignment: AlignmentDirectional.bottomStart,
      image: backgroundImage,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}

class TitleImageBackgroundCardSkeleton extends StatelessWidget {
  final double borderRadius;

  const TitleImageBackgroundCardSkeleton({super.key, this.borderRadius = 0});

  @override
  Widget build(BuildContext context) => Skeletonizer(
        enabled: true,
        child: TitleImageBackgroundCard(
          backgroundImage: ColoredBox(
            color: Colors.transparent,
          ),
          text: 'Just a fake data',
          borderRadius: borderRadius,
        ),
      );
}
