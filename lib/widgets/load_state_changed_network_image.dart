import 'package:flutter/material.dart';

import 'load_failed_placeholder.dart';
import 'loading_placeholder.dart';
import '../utils/future_network_image.dart';

class LoadStateChangedNetworkImage extends StatelessWidget {
  final String url;
  final String fallbackImageAssetName;
  final Color color;
  final double borderRadius;

  const LoadStateChangedNetworkImage(
      this.url,
      {super.key,
      required this.fallbackImageAssetName,
      required this.color,
      this.borderRadius = 0});

  @override
  Widget build(BuildContext context) {
    return FutureNetworkImage(
      url: url,
      loadingBuilder: (context, loadingProgress) {
        final value = loadingProgress?.expectedTotalBytes == null
            ? null
            : loadingProgress!.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!;

        return LoadingPlaceholder(
          value: value,
          backgroundImageAssetName: fallbackImageAssetName,
          color: color,
          borderRadius: borderRadius,
        );
      },
      failedBuilder: (context, reloadImage) => LoadFailedPlaceholder(
        reload: reloadImage,
        blurredImageAssetName: fallbackImageAssetName,
        color: color,
        borderRadius: borderRadius,
      ),
    );
  }
}
