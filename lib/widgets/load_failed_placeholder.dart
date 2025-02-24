import 'package:flutter/material.dart';

import 'blurred_box.dart';
import 'icon_alert.dart';

class LoadFailedPlaceholder extends StatelessWidget {
  final void Function() reload;
  final String blurredImageAssetName;
  final Color color;
  final double borderRadius;

  const LoadFailedPlaceholder(
      {super.key,
      required this.reload,
      required this.blurredImageAssetName,
      required this.color,
      this.borderRadius = 0});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: reload,
        child: BlurredBox(
          borderRadius: borderRadius,
          alignment: Alignment.center,
          imageAssetName: blurredImageAssetName,
          child: IconAlert(
            textColor: color,
            iconColor: color,
            iconData: Icons.refresh_rounded,
            content: 'Click to Retry',
          ),
        ),
      );
}
