import 'package:flutter/material.dart';

import '../constants/layout.dart';

class IconAlert extends StatelessWidget {
  final IconData iconData;
  final String content;
  final Color? textColor;
  final Color? iconColor;
  final List<Widget>? actions;

  const IconAlert(
      {super.key,
      required this.iconData,
      required this.content,
      this.textColor,
      this.iconColor,
      this.actions});

  static const _spacing = Spacing.paddingIncrement * 2;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        iconData,
        size: 48,
        color: iconColor,
      ),
      DefaultTextStyle.merge(
        style: TextStyle(
          color: textColor,
        ),
        child: Text(content),
      ),
    ];
    if (actions != null) {
      items.addAll([
        SizedBox(height: _spacing),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: actions!,
        ),
      ]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }
}
