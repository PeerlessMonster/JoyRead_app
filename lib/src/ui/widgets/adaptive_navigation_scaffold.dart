import 'package:flutter/material.dart';

import '../core/page_navigation_destination.dart';
import '../core/pressed_action.dart';
import '../core/responsive_layout_builder.dart';
import 'navigation_sidebar.dart';

class AdaptiveNavigationScaffold extends StatefulWidget {
  final Widget narrowScreenBody;
  /// If null, [narrowScreenBody] will always be built.
  final Widget? wideScreenBody;
  final List<PageNavigationDestination> navigationDestinations;
  final PressedAction floatingAction;

  final int selectedIndex;
  final void Function(int) setSelectedIndex;

  int get reversedSelectedIndex => _reverseDestinationIndex(selectedIndex);

  void setReversedSelectedIndex(int index) =>
      setSelectedIndex(_reverseDestinationIndex(index));

  const AdaptiveNavigationScaffold(
      {super.key,
      required this.narrowScreenBody,
      this.wideScreenBody,
      required this.navigationDestinations,
      required this.floatingAction,
      required this.selectedIndex,
      required this.setSelectedIndex});

  int _reverseDestinationIndex(int index) =>
      navigationDestinations.length - 1 - index;

  @override
  State<AdaptiveNavigationScaffold> createState() =>
      _AdaptiveNavigationScaffoldState();
}

class _AdaptiveNavigationScaffoldState
    extends State<AdaptiveNavigationScaffold> {
  @override
  Widget build(BuildContext context) => ResponsiveLayoutBuilder(
        narrowScreenWidget: Scaffold(
          body: SafeArea(
            child: widget.narrowScreenBody,
          ),
          bottomNavigationBar: NavigationBar(
            destinations: widget.navigationDestinations
                .map((navigationDestination) => NavigationDestination(
                      icon: navigationDestination.icon,
                      label: navigationDestination.name,
                    ))
                .toList(),
            selectedIndex: widget.selectedIndex,
            onDestinationSelected: widget.setSelectedIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            isExtended: true,
            shape: CircleBorder(),
            child: widget.floatingAction.icon,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
        wideScreenWidget: Scaffold(
          body: Row(children: [
            NavigationSidebar(
              navigationDestinations:
                  widget.navigationDestinations.reversed.toList(),
              floatingAction: widget.floatingAction,
              selectedIndex: widget.reversedSelectedIndex,
              onDestinationsSelected: widget.setReversedSelectedIndex,
            ),
            Expanded(
              child: widget.wideScreenBody ?? widget.narrowScreenBody,
            ),
          ]),
        ),
      );
}
