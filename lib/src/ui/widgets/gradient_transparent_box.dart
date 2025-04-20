import 'package:flutter/material.dart';

class GradientTransparentBox extends StatelessWidget {
  final Widget? child;
  final Widget image;
  final List<Color> colors;
  final List<double>? stops;
  final AlignmentGeometry alignment;

  const GradientTransparentBox(
      {super.key,
      required this.image,
      required this.colors,
      this.stops,
      this.alignment = AlignmentDirectional.topStart,
      this.child});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Positioned.fill(child: image),
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: stops,
            ),
          ),
        ),
      ),
    ];
    if (child != null) {
      items.add(child!);
    }
    return Stack(
      alignment: alignment,
      children: items,
    );
  }
}
