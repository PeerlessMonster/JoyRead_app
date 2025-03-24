import 'package:flutter/material.dart';

import 'ui/core/breakpoint_state.dart';
import 'ui/core/page_navigation_destination.dart';
import 'ui/core/pressed_action.dart';
import 'ui/pages/explore.dart';
import 'ui/pages/user_home.dart';
import 'ui/widgets/adaptive_navigation_scaffold.dart';

const _navigationDestinations = [
  PageNavigationDestination(
    name: 'Explore',
    icon: Icon(Icons.explore_rounded),
  ),
  PageNavigationDestination(
    name: 'Me',
    icon: Icon(Icons.account_circle_rounded),
  ),
];
final _floatingAction = PressedAction(
  name: 'Search',
  icon: Icon(Icons.search_rounded),
  onPressed: () {},
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final page = switch (currentPageIndex) {
      0 => ExplorePage(),
      1 => UserHomePage(),
      _ => throw UnimplementedError("No widget for $currentPageIndex")
    };

    return AdaptiveNavigationScaffold(
      navigationDestinations: _navigationDestinations,
      floatingAction: _floatingAction,
      selectedIndex: currentPageIndex,
      setSelectedIndex: (index) => setState(() {
        currentPageIndex = index;
      }),
      narrowScreenBody: BreakpointProvider(child: page),
    );
  }
}
