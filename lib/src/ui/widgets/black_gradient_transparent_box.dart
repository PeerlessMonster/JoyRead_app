import 'package:flutter/material.dart';

class BottomBlackGradientTransparentBox extends StatelessWidget {
  final Widget? child;
  final Widget image;
  final AlignmentGeometry alignment;
  final double beginStop;
  final double endStop;

  const BottomBlackGradientTransparentBox(
      {super.key,
      required this.beginStop,
      required this.endStop,
      this.alignment = AlignmentDirectional.bottomStart,
      required this.image,
      this.child})
      : assert(beginStop >= 0 && beginStop <= 1 && endStop >= 0 && endStop <= 1,
            'Both stop of begin and end should be a fraction from 0.0 to 1.0'),
        assert(beginStop < endStop, 'Stop of begin should be earlier than end');

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Positioned.fill(child: image),
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [beginStop, endStop],
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
