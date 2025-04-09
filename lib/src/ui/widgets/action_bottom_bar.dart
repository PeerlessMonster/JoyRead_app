import 'package:flutter/material.dart';

import '../core/pressed_action.dart';
import '../core/themes/constants/spacing.dart' as spacing;

class ActionBottomBar extends StatelessWidget {
  final List<PressedAction> primaryActions;
  final List<PressedAction> secondaryActions;

  const ActionBottomBar(
      {super.key,
      required this.primaryActions,
      required this.secondaryActions});

  @override
  Widget build(BuildContext context) => BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: secondaryActions.reversed
                  .map((secondaryAction) => IconButton(
                        tooltip: secondaryAction.name,
                        icon: secondaryAction.icon,
                        onPressed: secondaryAction.onPressed,
                      ))
                  .toList(),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(end: 68),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: spacing.Padding.targetSpacing,
                children: primaryActions.reversed
                    .map((primaryAction) => IconButton.outlined(
                          tooltip: primaryAction.name,
                          icon: primaryAction.icon,
                          onPressed: primaryAction.onPressed,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      );
}
