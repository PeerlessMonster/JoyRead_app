import 'package:flutter/material.dart';

import '../core/themes/constants/style.dart';

class NotificationBanner extends StatelessWidget {
  final String text;
  final Widget icon;
  final void Function() onClose;
  final bool capsuleShaped;
  /// Taking effect when [capsuledShaped] is true.
  final double? elevation;

  const NotificationBanner(
      {super.key,
      required this.text,
      required this.icon,
      required this.onClose,
      this.capsuleShaped = false,
      this.elevation});

  Widget _buildCloseButton(Color color) => IconButton(
        tooltip: 'Dismiss',
        icon: Icon(
          Icons.close_rounded,
          color: color,
        ),
        onPressed: onClose,
      );

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = brightness == Brightness.light
        ? colorScheme.inverseSurface
        : colorScheme.onSurface;
    final foregroundColor = brightness == Brightness.light
        ? colorScheme.onInverseSurface
        : colorScheme.surface;

    return capsuleShaped
        ? Material(
            elevation: elevation ?? DropShadow.elevation,
            shape: const StadiumBorder(),
            child: ClipPath.shape(
              shape: const StadiumBorder(),
              child: MaterialBanner(
                dividerColor: backgroundColor,
                backgroundColor: backgroundColor,
                leading: icon,
                contentTextStyle: TextStyle(
                  color: foregroundColor,
                ),
                content: Text(text),
                actions: [_buildCloseButton(foregroundColor)],
              ),
            ),
          )
        : MaterialBanner(
            backgroundColor: backgroundColor,
            leading: icon,
            contentTextStyle: TextStyle(
              color: foregroundColor,
            ),
            content: Text(text),
            actions: [_buildCloseButton(foregroundColor)],
          );
  }
}
