import 'package:flutter/material.dart';

import 'alert.dart';
import 'retry_button.dart';
import 'translucent_white_box.dart';

class NoNetworkImageBackgroundSign extends StatelessWidget {
  final void Function() retry;
  final String backgroundImageAssetName;
  final double borderRadius;

  const NoNetworkImageBackgroundSign(
      {super.key,
      required this.retry,
      required this.backgroundImageAssetName,
      this.borderRadius = 0});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TranslucentWhiteBox(
      borderRadius: borderRadius,
      alignment: Alignment.center,
      imageAssetName: backgroundImageAssetName,
      child: IconAlert(
        textColor: Colors.black,
        iconColor: colorScheme.error,
        iconData: Icons.error_rounded,
        content: 'Unable to access network.',
        actions: [
          RetryButton(
            retry: retry,
          ),
        ],
      ),
    );
  }
}
