import 'package:flutter/material.dart';

import '../core/themes/constants/spacing.dart' as spacing;

class Sign extends StatelessWidget {
  final String text;
  final String imageAssetName;
  final Widget? action;

  const Sign(
      {super.key,
      required this.imageAssetName,
      required this.text,
      this.action});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      SizedBox.square(
        dimension: 200,
        child: Image.asset(imageAssetName),
      ),
      Text(text),
    ];
    if (action != null) {
      items.addAll([
        SizedBox(height: spacing.Padding.increment * 3),
        action!,
      ]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }
}
