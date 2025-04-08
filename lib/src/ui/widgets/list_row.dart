import 'package:flutter/material.dart';

import '../core/themes/constants/dimension.dart' as dimension;
import '../core/themes/constants/style.dart';
import 'skeleton.dart';

const _padding = EdgeInsets.symmetric(
    horizontal: dimension.ListTile.contentHorizontalPadding);

const _icon = Icon(Icons.arrow_right_rounded);

class ListRow extends StatelessWidget {
  final String title;
  final Widget leading;
  final void Function() onTap;

  const ListRow(
      {super.key,
      required this.title,
      required this.leading,
      required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RoundedCorner.cardBorderRadius),
        ),
        contentPadding: _padding,
        leading: leading,
        title: Text(title),
        trailing: _icon,
        onTap: onTap,
      );
}

class ListRowSkeleton extends StatelessWidget {
  final bool isLoading;
  final Widget leading;

  const ListRowSkeleton(
      {super.key, required this.isLoading, required this.leading});

  @override
  Widget build(BuildContext context) => ListTileSkeleton(
        contentPadding: _padding,
        leading: leading,
        widthAsWordCount: 4,
        trailing: _icon,
        playAnimation: isLoading,
      );
}
