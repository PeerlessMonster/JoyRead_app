import 'package:flutter/material.dart';

import '../core/pressed_action.dart';
import '../core/themes/constants/dimension.dart' as dimension;
import '../core/themes/constants/spacing.dart' as spacing;

class ActionSidebar extends StatelessWidget {
  final PressedAction floatingAction;
  final List<PressedAction> primaryActions;
  final List<PressedAction> secondaryActions;

  const ActionSidebar(
      {super.key,
      required this.floatingAction,
      required this.primaryActions,
      required this.secondaryActions});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: dimension.NavigationRail.width,
      child: ColoredBox(
        color: colorScheme.surfaceContainer,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: dimension.NavigationRail.verticalPadding,
              horizontal: dimension.NavigationRail.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                tooltip: 'Back',
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: spacing.Padding.targetSpacing,
                    children: [
                      FloatingActionButton(
                        onPressed: floatingAction.onPressed,
                        shape: CircleBorder(),
                        tooltip: floatingAction.name,
                        child: floatingAction.icon,
                      ),
                      ...primaryActions
                          .map((primaryAction) => IconButton.filledTonal(
                                tooltip: primaryAction.name,
                                icon: primaryAction.icon,
                                onPressed: primaryAction.onPressed,
                              )),
                    ],
                  ),
                  Divider(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: spacing.Padding.targetSpacing,
                    children: secondaryActions
                        .map((secondaryAction) => IconButton(
                              tooltip: secondaryAction.name,
                              icon: secondaryAction.icon,
                              onPressed: secondaryAction.onPressed,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
