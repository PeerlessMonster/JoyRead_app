import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class TranslucentWhiteBox extends StatelessWidget {
  final Widget? child;
  final String imageAssetName;
  final AlignmentGeometry alignment;
  final double borderRadius;

  /// While no passing [child], [alignment] will be ignored.
  const TranslucentWhiteBox(
      {super.key,
      required this.imageAssetName,
      this.alignment = AlignmentDirectional.topStart,
      this.borderRadius = 0,
      this.child});

  static const _kilobyte512 = 512 * 1024;

  Widget _buildTranslucence() => ExtendedImage.asset(
        imageAssetName,
        maxBytes: _kilobyte512,
        fit: BoxFit.cover,
        opacity: AlwaysStoppedAnimation(0.22),
      );

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child == null
            ? _buildTranslucence()
            : Stack(
                alignment: alignment,
                children: [
                  Positioned.fill(
                    child: _buildTranslucence(),
                  ),
                  child!
                ],
              ),
      );
}
