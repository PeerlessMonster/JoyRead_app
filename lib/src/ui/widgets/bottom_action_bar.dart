import 'package:flutter/material.dart';

import '../core/pressed_action.dart';
import '../core/themes/constants/dimension.dart' as dimension;

class BottomActionBar extends StatelessWidget {
  final List<PressedAction> primaryActions;
  final List<PressedAction> secondaryActions;

  const BottomActionBar(
      {super.key,
      required this.primaryActions,
      required this.secondaryActions});

  @override
  Widget build(BuildContext context) => BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: dimension.NavigationRail.spacing,
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
                spacing: dimension.NavigationRail.spacing,
                children: primaryActions.reversed
                    .map((primaryAction) => IconButton.filledTonal(
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
