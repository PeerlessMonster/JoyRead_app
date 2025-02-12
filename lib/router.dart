import 'package:flutter/material.dart';

import 'pages/explore.dart';
import 'pages/user_home.dart';
import 'widgets/adaptive_scaffold.dart';

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

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final page = switch (_currentPageIndex) {
      0 => ExplorePage(),
      1 => UserHomePage(),
      _ => throw UnimplementedError("No widget for $_currentPageIndex")
    };

    return AdaptiveScaffold(
      navigationDestinations: _navigationDestinations,
      floatingActionButtonDestination: _floatingActionButtonDestination,
      selectedIndex: _currentPageIndex,
      setSelectedIndex: (index) => setState(() {
        _currentPageIndex = index;
      }),
      body: page,
    );
  }
}
