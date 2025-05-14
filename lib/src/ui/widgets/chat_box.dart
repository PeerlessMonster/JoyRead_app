import 'package:flutter/material.dart';

import '../core/responsive_margin.dart';
import '../core/themes/constants/spacing.dart' as spacing;
import 'sending_text_field.dart';

class ChatBox extends StatelessWidget {
  final List<Widget> children;
  final void Function(String value) onSent;
  final String? hintText;

  const ChatBox(
      {super.key, required this.onSent, this.hintText, required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(children: [
      Expanded(
        child: ListView.builder(
          reverse: true,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: spacing.Padding.increment * 2),
            child: children[index],
          ),
          itemCount: children.length,
        ),
      ),
      DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: calculateResponsiveMarginValue(context),
              vertical: spacing.Padding.targetSpacing),
          child: SendingTextField(
            hintText: hintText,
            onSent: onSent,
          ),
        ),
      )
    ]);
  }
}
