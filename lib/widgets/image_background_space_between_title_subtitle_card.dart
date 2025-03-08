import 'package:flutter/material.dart';

import '../constants/layout.dart';
import 'scroll_parallax_image.dart';
import 'skeleton.dart';
import 'translucent_black_box.dart';

class ImageBackgroundTitleSubtitleCard extends StatelessWidget {
  final String title;
  final String label;
  final Widget backgroundImage;
  final bool scrollBackgroundParallax;
  final double borderRadius;
  static const _padding = Spacing.paddingIncrement * 4;

  const ImageBackgroundTitleSubtitleCard(
      {super.key,
      required this.title,
      required this.label,
      required this.backgroundImage,
      this.scrollBackgroundParallax = false,
      this.borderRadius = 0});

  static const titleStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const labelStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    return TranslucentBlackBox(
      borderRadius: borderRadius,
      image: scrollBackgroundParallax
          ? ScrollParallaxImage(
              image: backgroundImage,
            )
          : backgroundImage,
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle.merge(
                style: titleStyle,
                child: Text(
                  title,
                  style: titleStyle,
                ),
              ),
              DefaultTextStyle.merge(
                style: labelStyle,
                child: Text(
                  label,
                  style: labelStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageBackgroundTitleLabelCardSkeleton extends StatelessWidget {
  final bool isLoading;
  final double borderRadius;

  const ImageBackgroundTitleLabelCardSkeleton(
      {super.key, required this.isLoading, this.borderRadius = 0});

  @override
  Widget build(BuildContext context) => Skeleton(
        playEffect: isLoading,
        child: TranslucentBlackBox(
          borderRadius: borderRadius,
          image: ColoredBox(
            color: Colors.transparent,
          ),
        ),
      );
}
