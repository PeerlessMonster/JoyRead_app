import 'package:flutter/material.dart';

class GradientTransparentBox extends StatelessWidget {
  final Widget? child;
  final Widget image;
  final AlignmentGeometry alignment;
  final double borderRadius;

  const GradientTransparentBox(
      {super.key,
      required this.image,
      this.alignment = AlignmentDirectional.bottomStart,
      this.borderRadius = 0,
      this.child});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Positioned.fill(child: image),
      Positioned.fill(
        child: AbsorbPointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.6, 0.8],
              ),
            ),
          ),
        ),
      ),
    ];
    if (child != null) {
      items.add(child!);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        alignment: alignment,
        children: items,
      ),
    );
  }
}
