import 'package:flutter/material.dart';

class TranslucentBlackBox extends StatelessWidget {
  final Widget? child;
  final Widget image;
  final AlignmentGeometry alignment;
  final double borderRadius;

  const TranslucentBlackBox(
      {super.key,
      required this.image,
      this.alignment = AlignmentDirectional.topStart,
      this.borderRadius = 0,
      this.child});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Positioned.fill(child: image),
      Positioned.fill(
        child: ColoredBox(
          color: Colors.black.withValues(alpha: 0.5),
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
