import 'package:flutter/material.dart';

import '../core/responsive_margin.dart';
import '../core/themes/constants/dimension.dart' as dimension;
import '../core/themes/constants/spacing.dart' as spacing;

enum RowChatMessageAlignment { start, end }

class RowChatMessage extends StatelessWidget {
  final Widget content;
  final Widget avatar;
  final RowChatMessageAlignment alignment;
  static const _avatarSize = dimension.CircleAvatar.size;
  static const _spacing = spacing.Padding.targetSpacing / 2;

  const RowChatMessage(
      {super.key,
      required this.content,
      required this.avatar,
      required this.alignment});

  Widget _buildCard() => Card(
        child: Padding(
          padding: EdgeInsets.all(spacing.Margin.allSides),
          child: content,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final edgeInsets = calculateResponsiveMarginValue(context);

    return Padding(
      padding: alignment == RowChatMessageAlignment.start
          ? EdgeInsetsDirectional.only(
              start: edgeInsets, end: _spacing + _avatarSize + edgeInsets)
          : EdgeInsetsDirectional.only(
              start: edgeInsets + _avatarSize + edgeInsets, end: edgeInsets),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: _spacing,
        children: alignment == RowChatMessageAlignment.start
            ? [
                CircleAvatar(
                  child: avatar,
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _buildCard(),
                  ),
                ),
              ]
            : [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: _buildCard(),
                  ),
                ),
                CircleAvatar(
                  child: avatar,
                ),
              ],
      ),
    );
  }
}
