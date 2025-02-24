import 'package:flutter/material.dart';

import 'blurred_box.dart';

class LoadingPlaceholder extends StatelessWidget {
  final double? value;
  final String backgroundImageAssetName;
  final Color color;
  final double borderRadius;

  const LoadingPlaceholder(
      {super.key,
      this.value,
      required this.backgroundImageAssetName,
      required this.color,
      this.borderRadius = 0});

  @override
  Widget build(BuildContext context) => BlurredBox(
        borderRadius: borderRadius,
        alignment: Alignment.center,
        imageAssetName: backgroundImageAssetName,
        child: CircularProgressIndicator(
          value: value,
          color: color,
          backgroundColor: color.withValues(alpha: 0.1),
        ),
      );
}
