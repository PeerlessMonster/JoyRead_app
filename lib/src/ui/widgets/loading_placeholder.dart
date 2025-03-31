import 'package:flutter/material.dart';

import 'blurred_box.dart';

class LoadingPlaceholder extends StatelessWidget {
  final double? value;
  final String backgroundImageAssetName;
  final Color foregroundColor;

  const LoadingPlaceholder(
      {super.key,
      this.value,
      required this.backgroundImageAssetName,
      required this.foregroundColor});

  @override
  Widget build(BuildContext context) => BlurredBox(
        alignment: Alignment.center,
        imageAssetName: backgroundImageAssetName,
        child: CircularProgressIndicator(
          value: value,
          color: foregroundColor,
          backgroundColor: foregroundColor.withValues(alpha: 0.1),
        ),
      );
}
