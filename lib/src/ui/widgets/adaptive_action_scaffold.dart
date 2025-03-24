import 'package:flutter/material.dart';

import '../core/pressed_action.dart';
import '../core/responsive_layout_builder.dart';
import 'action_sidebar.dart';
import 'bottom_action_bar.dart';

class AdaptiveActionScaffold extends StatelessWidget {
  final Widget narrowScreenBody;
  /// If null, [narrowScreenBody] will always be built.
  final Widget? wideScreenBody;
  final PressedAction floatingAction;
  final List<PressedAction> primaryActions;
  final List<PressedAction> secondaryActions;

  const AdaptiveActionScaffold(
      {super.key,
      required this.narrowScreenBody,
      this.wideScreenBody,
      required this.floatingAction,
      required this.primaryActions,
      required this.secondaryActions});

  @override
  Widget build(BuildContext context) => ResponsiveLayoutBuilder(
        narrowScreenWidget: Scaffold(
          body: narrowScreenBody,
          bottomNavigationBar: BottomActionBar(
            primaryActions: primaryActions,
            secondaryActions: secondaryActions,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: floatingAction.onPressed,
            tooltip: floatingAction.name,
            shape: CircleBorder(),
            child: floatingAction.icon,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ),
        wideScreenWidget: Scaffold(
          body: Row(children: [
            ActionSidebar(
              primaryActions: primaryActions,
              floatingAction: floatingAction,
              secondaryActions: secondaryActions,
            ),
            Expanded(
              child: wideScreenBody ?? narrowScreenBody,
            ),
          ]),
        ),
      );
}
