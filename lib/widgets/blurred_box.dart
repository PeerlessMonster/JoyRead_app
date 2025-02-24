import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class BlurredBox extends StatelessWidget {
  final Widget? child;
  final String imageAssetName;
  final AlignmentGeometry alignment;
  final double borderRadius;

  /// While no passing [child], [alignment] will be ignored.
  const BlurredBox(
      {super.key,
      required this.imageAssetName,
      this.child,
      this.alignment = AlignmentDirectional.topStart,
      this.borderRadius = 0});

  static const _kilobyte1 = 1 * 1024;

  Widget _buildBlur() => ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: ExtendedImage.asset(
          imageAssetName,
          maxBytes: _kilobyte1,
          fit: BoxFit.cover,
        ),
      );

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
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
