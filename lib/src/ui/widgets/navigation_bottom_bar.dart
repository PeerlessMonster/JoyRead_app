import 'package:flutter/material.dart';

import '../core/page_navigation_destination.dart';

class NavigationBottomBar extends StatelessWidget {
  final List<PageNavigationDestination> navigationDestinations;
  final int selectedIndex;
  final void Function(int) onDestinationSelected;

  const NavigationBottomBar(
      {super.key,
      required this.navigationDestinations,
      required this.selectedIndex,
      required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
        ),
      ),
      NavigationBar(
        backgroundColor: Colors.transparent,
        destinations: navigationDestinations
            .map((destination) => NavigationDestination(
                  tooltip: '',
                  label: destination.name,
                  icon: destination.icon,
                ))
            .toList(),
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    ]);
  }
}
