import 'package:flutter/material.dart';

import '../core/themes/constants/dimension.dart' as dimension;
import 'blurred_box.dart';

class LoadFailedPlaceholder extends StatelessWidget {
  final void Function() reload;
  final String backgroundImageAssetName;
  final Color foregroundColor;

  const LoadFailedPlaceholder(
      {super.key,
      required this.reload,
      required this.backgroundImageAssetName,
      required this.foregroundColor});

  @override
  Widget build(BuildContext context) => BlurredBox(
        alignment: Alignment.center,
        imageAssetName: backgroundImageAssetName,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: dimension.Icon.size * 2,
              color: foregroundColor,
              icon: Icon(Icons.refresh_rounded),
              onPressed: reload,
            ),
            Text(
              'Click to retry',
              style: TextStyle(
                color: foregroundColor,
              ),
            )
          ],
        ),
      );
}
