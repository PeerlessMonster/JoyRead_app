import 'package:flutter/material.dart';

import '../core/responsive_margin.dart';
import '../core/themes/constants/spacing.dart' as spacing;
import 'text_sending_bar.dart';

class ChatBox extends StatelessWidget {
  final List<Widget> children;
  final void Function(String value) onSent;
  final String? hintText;
  /// Defaults to [ColorScheme.surfaceContainerLowest].
  final Color? inputBoxBackgroundColor;
  /// Defaults to [Colors.transparent].
  final Color? messageListViewBackgroundColor;
  static const _padding = spacing.Padding.targetSpacing;

  const ChatBox(
      {super.key,
      required this.onSent,
      this.hintText,
      this.inputBoxBackgroundColor,
      this.messageListViewBackgroundColor,
      required this.children});

  Widget _buildListView() => ListView.builder(
        reverse: true,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(
              top: index == children.length - 1 ? _padding : 0,
              bottom: _padding),
          child: children[index],
        ),
        itemCount: children.length,
      );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(children: [
      Expanded(
        child: messageListViewBackgroundColor == null
            ? _buildListView()
            : ColoredBox(
                color: messageListViewBackgroundColor!,
                child: _buildListView(),
              ),
      ),
      Divider(height: 1),
      ColoredBox(
        color: inputBoxBackgroundColor ?? colorScheme.surfaceContainerLowest,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: calculateResponsiveMarginValue(context),
              vertical: _padding),
          child: TextSendingBar(
            hintText: hintText,
            onSent: onSent,
          ),
        ),
      ),
    ]);
  }
}
