import 'package:flutter/material.dart';

import '../core/page_navigation_destination.dart';
import '../core/pressed_action.dart';
import '../core/themes/constants/animation.dart';
import 'adaptive_scaffold.dart';
import 'navigation_bottom_bar.dart';
import 'navigation_sidebar.dart';

class NavigationScaffold extends StatelessWidget {
  final Widget body;
  final List<PageNavigationDestination> navigationDestinations;
  final PressedAction floatingAction;
  final int selectedIndex;
  final void Function(int) setSelectedIndex;

  const NavigationScaffold(
      {super.key,
      required this.body,
      required this.navigationDestinations,
      required this.floatingAction,
      required this.selectedIndex,
      required this.setSelectedIndex});

  int _reversedDestinationIndex(int index) =>
      navigationDestinations.length - 1 - index;

  @override
  Widget build(BuildContext context) => AnimatedAdaptiveScaffold(
        body: body,
        wideScreenSidebar: NavigationSidebar(
          navigationDestinations: navigationDestinations.reversed.toList(),
          floatingAction: floatingAction,
          selectedIndex: _reversedDestinationIndex(selectedIndex),
          onDestinationsSelected: (index) =>
              setSelectedIndex(_reversedDestinationIndex(index)),
        ),
        narrowScreenBottomBar: NavigationBottomBar(
          navigationDestinations: navigationDestinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: setSelectedIndex,
        ),
        narrowScreenFloatingActionButton: FloatingActionButton(
          onPressed: floatingAction.onPressed,
          heroTag: HeroTag.scaffoldFloatingActionButton,
          shape: CircleBorder(),
          child: floatingAction.icon,
        ),
        narrowScreenFloatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
      );
}
