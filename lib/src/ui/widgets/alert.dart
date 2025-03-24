import 'package:flutter/material.dart';

import '../core/themes/constants/spacing.dart' as spacing;

class _BaseAlert extends StatelessWidget {
  final Widget sign;
  final String content;
  final Color? textColor;
  final double spacing;
  final List<Widget>? actions;

  const _BaseAlert(
      {super.key,
      required this.sign,
      required this.content,
      this.textColor,
      this.spacing = 0,
      this.actions});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      sign,
      DefaultTextStyle.merge(
        style: TextStyle(
          color: textColor,
        ),
        child: Text(content),
      ),
    ];
    if (actions != null) {
      items.addAll([
        SizedBox(height: spacing),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: actions!,
        )
      ]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }
}

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

  @override
  Widget build(BuildContext context) => _BaseAlert(
        sign: Icon(
          iconData,
          size: 48,
          color: iconColor,
        ),
        textColor: textColor,
        content: content,
        spacing: spacing.Padding.increment * 2,
        actions: actions,
      );
}

class ImageAlert extends StatelessWidget {
  final Widget image;
  final String content;
  final Color? textColor;
  final List<Widget>? actions;

  const ImageAlert(
      {super.key,
      required this.image,
      required this.content,
      this.textColor,
      this.actions});

  @override
  Widget build(BuildContext context) => _BaseAlert(
        sign: SizedBox.square(
          dimension: 200,
          child: image,
        ),
        textColor: textColor,
        content: content,
        spacing: spacing.Padding.increment * 5,
        actions: actions,
      );
}
