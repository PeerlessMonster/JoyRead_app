import 'package:flutter/material.dart';

import '../../utils/breakpoint.dart';
import '../core/breakpoint_state.dart';
import 'navigation_sidebar.dart';

class AdaptiveScaffold extends StatefulWidget {
  final Widget body;
  final List<NavigationDestination> navigationDestinations;
  final NavigationDestination floatingActionButtonDestination;

  final int selectedIndex;
  final void Function(int) setSelectedIndex;

  int get reversedSelectedIndex => _reverseDestinationIndex(selectedIndex);

  void setReversedSelectedIndex(int index) =>
      setSelectedIndex(_reverseDestinationIndex(index));

  const AdaptiveScaffold(
      {super.key,
      required this.navigationDestinations,
      required this.floatingActionButtonDestination,
      required this.selectedIndex,
      required this.setSelectedIndex,
      required this.body});

  int _reverseDestinationIndex(int index) =>
      navigationDestinations.length - 1 - index;

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold>
    with BreakpointState<AdaptiveScaffold> {
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
                        label: Text(navigationDestination.label),
                      ))
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
