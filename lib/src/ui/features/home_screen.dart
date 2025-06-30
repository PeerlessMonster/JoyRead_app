import 'package:flutter/material.dart';

import '../core/breakpoint_state.dart';
import '../core/page_navigation_destination.dart';
import '../core/pressed_action.dart';
import '../widgets/adaptive_network_notification_display_container.dart';
import '../widgets/navigation_scaffold.dart';
import 'explore_page.dart';
import 'search/views/search_screen.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentPageIndex = 0;

  @override
  Widget build(BuildContext context) => NavigationScaffold(
        body: BreakpointProvider(
          child: IndexedStack(
            index: currentPageIndex,
            children: [
              ExplorePage(),
              UserCenterPage(),
            ]
                .map((page) =>
                    AdaptiveNetworkNotificationDisplayContainer(body: page))
                .toList(),
          ),
        ),
        navigationDestinations: _navigationDestinations,
        floatingAction: PressedAction(
          name: 'Search',
          icon: Icon(Icons.search_rounded),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              )),
        ),
        selectedIndex: currentPageIndex,
        setSelectedIndex: (index) => setState(() {
          currentPageIndex = index;
        }),
      );
}
