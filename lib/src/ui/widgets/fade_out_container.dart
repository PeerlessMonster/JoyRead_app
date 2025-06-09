import 'package:flutter/material.dart';

enum FadeOutPosition { top, bottom }

class FadeOutContainer extends StatelessWidget {
  final Widget child;
  final Color outColor;
  final FadeOutPosition position;
  final double fadeHeight;

  const FadeOutContainer(
      {super.key,
      required this.outColor,
      this.position = FadeOutPosition.bottom,
      required this.fadeHeight,
      required this.child});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    return Stack(children: [
      child,
      Positioned(
        left: 0,
        top: position == FadeOutPosition.top ? 0 : null,
        right: 0,
        bottom: position == FadeOutPosition.bottom ? 0 : null,
        height: fadeHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: position == FadeOutPosition.bottom
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              end: position == FadeOutPosition.bottom
                  ? Alignment.bottomCenter
                  : Alignment.topCenter,
              colors: [
                (brightness == Brightness.light ? Colors.white : Colors.black)
                    .withValues(alpha: 0),
                outColor.withValues(alpha: 0.9)
              ],
              stops: const [0, 1],
            ),
          ),
        ),
      ),
    ]);
  }
}
