import 'package:flutter/material.dart';

import '../core/page_navigation_destination.dart';
import '../core/pressed_action.dart';
import 'navigation_sidebar.dart';

class WideScreenNavigationScaffold extends StatelessWidget {
  final Widget body;
  final List<PageNavigationDestination> navigationDestinations;
  final PressedAction floatingAction;
  final int selectedIndex;
  final void Function(int) setSelectedIndex;

  const WideScreenNavigationScaffold(
      {super.key,
      required this.body,
      required this.navigationDestinations,
      required this.floatingAction,
      required this.selectedIndex,
      required this.setSelectedIndex});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(
          children: [
            NavigationSidebar(
              navigationDestinations: navigationDestinations,
              floatingAction: floatingAction,
              selectedIndex: selectedIndex,
              onDestinationsSelected: setSelectedIndex,
            ),
            Expanded(
              child: body,
            ),
          ],
        ),
      );
}
