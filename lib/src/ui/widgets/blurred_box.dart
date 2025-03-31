import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class BlurredBox extends StatelessWidget {
  final Widget? child;
  final String imageAssetName;
  final AlignmentGeometry alignment;

  /// While no passing [child], [alignment] will be ignored.
  const BlurredBox(
      {super.key,
      required this.imageAssetName,
      this.child,
      this.alignment = AlignmentDirectional.topStart});

  static const _kilobyte1 = 1 * 1024;

  Widget _buildBlur() => ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: ExtendedImage.asset(
          imageAssetName,
          clearMemoryCacheWhenDispose: true,
          maxBytes: _kilobyte1,
          fit: BoxFit.cover,
        ),
      );

  @override
  Widget build(BuildContext context) => ClipRect(
        child: child == null
            ? _buildBlur()
            : Stack(
                alignment: alignment,
                children: [
                  Positioned.fill(
                    child: _buildBlur(),
                  ),
                  child!,
                ],
              ),
      );
}
