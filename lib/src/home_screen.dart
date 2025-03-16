import 'package:flutter/material.dart';

import 'ui/core/breakpoint_state.dart';
import 'ui/pages/explore.dart';
import 'ui/pages/user_home.dart';
import 'ui/widgets/adaptive_scaffold.dart';

const _navigationDestinations = [
  NavigationDestination(
    label: 'Explore',
    icon: Icon(Icons.explore_rounded),
  ),
  NavigationDestination(
    label: 'Me',
    icon: Icon(Icons.account_circle_rounded),
  ),
];
const _floatingActionButtonDestination = NavigationDestination(
  label: 'Search',
  icon: Icon(Icons.search_rounded),
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

    return AdaptiveScaffold(
      navigationDestinations: _navigationDestinations,
      floatingActionButtonDestination: _floatingActionButtonDestination,
      selectedIndex: currentPageIndex,
      setSelectedIndex: (index) => setState(() {
        currentPageIndex = index;
      }),
      body: BreakpointProvider(
        child: page,
      ),
    );
  }
}
