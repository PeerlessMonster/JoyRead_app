import 'package:flutter/material.dart';

import 'ui/core/breakpoint_state.dart';
import 'ui/core/page_navigation_destination.dart';
import 'ui/core/pressed_action.dart';
import 'ui/core/responsive_layout_builder.dart';
import 'ui/pages/explore.dart';
import 'ui/pages/user_home.dart';
import 'ui/widgets/narrow_screen_navigation_scaffold.dart';
import 'ui/widgets/wide_screen_navigation_scaffold.dart';

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

  int _reversePageIndex(int index) =>
      _navigationDestinations.length - 1 - index;

  Widget _buildBody() {
    final page = switch (currentPageIndex) {
      0 => ExplorePage(),
      1 => UserHomePage(),
      _ => throw UnimplementedError("No widget for $currentPageIndex")
    };
    return BreakpointProvider(
      child: page,
    );
  }

  @override
  Widget build(BuildContext context) => ResponsiveLayoutBuilder(
        narrowScreenWidget: NarrowScreenNavigationScaffold(
          body: _buildBody(),
          navigationDestinations: _navigationDestinations,
          floatingAction: _floatingAction,
          selectedIndex: currentPageIndex,
          setSelectedIndex: (index) => setState(() {
            currentPageIndex = index;
          }),
        ),
        wideScreenWidget: WideScreenNavigationScaffold(
          body: _buildBody(),
          navigationDestinations: _navigationDestinations.reversed.toList(),
          floatingAction: _floatingAction,
          selectedIndex: _reversePageIndex(currentPageIndex),
          setSelectedIndex: (index) => setState(() {
            currentPageIndex = _reversePageIndex(index);
          }),
        ),
      );
}
