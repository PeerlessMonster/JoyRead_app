import 'package:flutter/material.dart';

import 'icon_alert.dart';
import 'translucent_box.dart';

class NoNetworkPlaceholder extends StatelessWidget {
  final void Function() retry;
  final String backgroundImageAssetName;
  final double borderRadius;

  const NoNetworkPlaceholder(
      {super.key,
      required this.retry,
      required this.backgroundImageAssetName,
      this.borderRadius = 0});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TranslucentBox(
      borderRadius: borderRadius,
      alignment: Alignment.center,
      imageAssetName: backgroundImageAssetName,
      child: IconAlert(
        textColor: Colors.black,
        iconColor: colorScheme.error,
        iconData: Icons.error_rounded,
        content: 'Unable to access network.',
        actions: [
          FilledButton(
            onPressed: retry,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
