import 'package:flutter/material.dart';

import '../core/themes/constants/dimension.dart' as dimension;
import '../core/themes/constants/spacing.dart' as spacing;
import 'retry_button.dart';
import 'translucent_white_box.dart';

class NetworkErrorImageBackgroundSign extends StatelessWidget {
  final void Function() retry;
  final String backgroundImageAssetName;
  final double borderRadius;

  const NetworkErrorImageBackgroundSign(
      {super.key,
      required this.retry,
      required this.backgroundImageAssetName,
      this.borderRadius = 0});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: TranslucentWhiteBox(
        alignment: Alignment.center,
        imageAssetName: backgroundImageAssetName,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_rounded,
              color: colorScheme.error,
              size: dimension.Icon.size * 2,
            ),
            SizedBox(height: spacing.Padding.increment * 1),
            Text('Unable to access network.'),
            SizedBox(height: spacing.Padding.increment * 3),
            RetryButton(
              retry: retry,
            ),
          ],
        ),
      ),
    );
  }
}
