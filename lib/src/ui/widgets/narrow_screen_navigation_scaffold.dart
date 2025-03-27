import 'package:flutter/material.dart';

import '../core/page_navigation_destination.dart';
import '../core/pressed_action.dart';
import 'navigation_bottom_bar.dart';

class NarrowScreenNavigationScaffold extends StatelessWidget {
  final Widget body;
  final List<PageNavigationDestination> navigationDestinations;
  final PressedAction floatingAction;
  final int selectedIndex;
  final void Function(int) setSelectedIndex;

  const NarrowScreenNavigationScaffold(
      {super.key,
      required this.body,
      required this.navigationDestinations,
      required this.floatingAction,
      required this.selectedIndex,
      required this.setSelectedIndex});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: body,
        ),
        bottomNavigationBar: NavigationBottomBar(
          navigationDestinations: navigationDestinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: setSelectedIndex,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          isExtended: true,
          shape: CircleBorder(),
          child: floatingAction.icon,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
}
