import 'package:flutter/material.dart';

import '../pages/user.dart';
import '../pages/explore.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var _currentPageIndex = 0;
  static const _pages = [ExplorePage(), UserPage()];

  static const _destinations = [
    NavigationDestination(
      label: 'Explore',
      icon: Icon(Icons.explore_rounded),
    ),
    NavigationDestination(
      label: 'Me',
      icon: Icon(Icons.account_circle_rounded),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final windowWidth = MediaQuery.sizeOf(context).width;
    return windowWidth < 600
        ? Scaffold(
            body: SafeArea(
              child: _pages[_currentPageIndex],
            ),
            bottomNavigationBar: NavigationBar(
              destinations: _destinations,
              selectedIndex: _currentPageIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
            ),
          )
        : Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  destinations: _destinations
                      .map((destination) => NavigationRailDestination(
                          icon: destination.icon,
                          label: Text(destination.label)))
                      .toList(),
                  selectedIndex: _currentPageIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  extended: windowWidth >= 840,
                  groupAlignment: 0,
                  labelType: windowWidth < 840
                      ? NavigationRailLabelType.selected
                      : NavigationRailLabelType.none,
                  backgroundColor: colorScheme.surfaceContainer,
                ),
                Expanded(child: _pages[_currentPageIndex]),
              ],
            ),
          );
  }
}
