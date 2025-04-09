import 'package:flutter/material.dart';

import '../core/breakpoint_state.dart';
import '../core/page_navigation_destination.dart';
import '../core/pressed_action.dart';
import '../core/responsive_layout_builder.dart';
import '../widgets/narrow_screen_navigation_scaffold.dart';
import '../widgets/wide_screen_navigation_scaffold.dart';
import 'explore_page.dart';
import 'user_center_page.dart';

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
      1 => UserCenterPage(),
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
