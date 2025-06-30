import 'package:flutter/material.dart';

import '../core/themes/constants/style.dart';

enum MessageBannerBehavior { fixed, floating }

class MessageBanner extends StatelessWidget {
  final String text;
  final Widget icon;
  final List<Widget>? actions;
  final MessageBannerBehavior behavior;
  /// Take effect when [behavior] is [MessageBannerBehavior.floating].
  final ShapeBorder shape;
  /// Take effect when [behavior] is [MessageBannerBehavior.floating], default
  /// to [DropShadow.snackBarElevation].
  final double? elevation;

  const MessageBanner(
      {super.key,
      required this.text,
      required this.icon,
      this.actions,
      this.behavior = MessageBannerBehavior.fixed,
      this.shape = const StadiumBorder(),
      this.elevation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    final colorScheme = theme.colorScheme;
    // Equal to default [backgroundColor] of [SnackBar].
    final backgroundColor = brightness == Brightness.light
        ? colorScheme.inverseSurface
        : colorScheme.onSurface;
    final foregroundColor = brightness == Brightness.light
        ? colorScheme.onInverseSurface
        : colorScheme.surface;

    return behavior == MessageBannerBehavior.floating
        ? Material(
            elevation: elevation ?? DropShadow.snackBarElevation,
            shape: shape,
            child: ClipPath.shape(
              shape: shape,
              child: MaterialBanner(
                dividerColor: backgroundColor,
                backgroundColor: backgroundColor,
                leading: icon,
                contentTextStyle: TextStyle(color: foregroundColor),
                content: Text(text),
                actions: actions ?? <Widget>[],
              ),
            ),
          )
        : MaterialBanner(
            backgroundColor: backgroundColor,
            leading: icon,
            contentTextStyle: TextStyle(color: foregroundColor),
            content: Text(text),
            actions: actions ?? <Widget>[],
          );
  }
}
