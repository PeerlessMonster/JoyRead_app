import 'package:flutter/material.dart';

import '../constants/breakpoint.dart';
import '../utils/adaptive_state.dart';
import '../widgets/navigation_sidebar.dart';

class AdaptiveScaffold extends StatefulWidget {
  final Widget body;
  final List<NavigationDestination> navigationDestinations;
  final NavigationDestination floatingActionButtonDestination;

  final int selectedIndex;
  final void Function(int) setSelectedIndex;

  int get reversedSelectedIndex => reverseDestinationIndex(selectedIndex);

  void setReversedSelectedIndex(int index) =>
      setSelectedIndex(reverseDestinationIndex(index));

  const AdaptiveScaffold(
      {super.key,
      required this.navigationDestinations,
      required this.floatingActionButtonDestination,
      required this.selectedIndex,
      required this.setSelectedIndex,
      required this.body});

  int reverseDestinationIndex(int index) =>
      navigationDestinations.length - 1 - index;

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends AdaptiveState<AdaptiveScaffold> {
  @override
  Widget build(BuildContext context) => breakpoint <= Breakpoint.compact
      ? Scaffold(
          body: SafeArea(
            child: widget.body,
          ),
          bottomNavigationBar: NavigationBar(
            destinations: widget.navigationDestinations,
            selectedIndex: widget.selectedIndex,
            onDestinationSelected: widget.setSelectedIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            isExtended: true,
            shape: CircleBorder(),
            child: widget.floatingActionButtonDestination.icon,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        )
      : Scaffold(
          body: Row(children: [
            NavigationSidebar(
              navigationDestinations: widget.navigationDestinations.reversed
                  .map((navigationDestination) => NavigationRailDestination(
                      icon: navigationDestination.icon,
                      label: Text(navigationDestination.label)))
                  .toList(),
              floatingActionButtonDestination:
                  widget.floatingActionButtonDestination,
              selectedIndex: widget.reversedSelectedIndex,
              onDestinationsSelected: widget.setReversedSelectedIndex,
            ),
            Expanded(child: widget.body),
          ]),
        );
}
