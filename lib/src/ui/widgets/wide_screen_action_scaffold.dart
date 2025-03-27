import 'package:flutter/material.dart';

import '../core/pressed_action.dart';
import 'action_sidebar.dart';

class WideScreenActionScaffold extends StatelessWidget {
  final Widget body;
  final PressedAction floatingAction;
  final List<PressedAction> primaryActions;
  final List<PressedAction> secondaryActions;

  const WideScreenActionScaffold(
      {super.key,
      required this.body,
      required this.floatingAction,
      required this.primaryActions,
      required this.secondaryActions});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(
          children: [
            ActionSidebar(
              primaryActions: primaryActions,
              floatingAction: floatingAction,
              secondaryActions: secondaryActions,
            ),
            Expanded(
              child: body,
            ),
          ],
        ),
      );
}
