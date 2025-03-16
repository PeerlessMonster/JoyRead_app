import 'package:flutter/material.dart';

import 'extended_floating_action_button.dart';

class NavigationSidebar extends StatefulWidget {
  final List<NavigationRailDestination> navigationDestinations;
  final NavigationDestination floatingActionButtonDestination;
  final int selectedIndex;
  final void Function(int) onDestinationsSelected;

  const NavigationSidebar(
      {super.key,
      required this.navigationDestinations,
      required this.floatingActionButtonDestination,
      required this.selectedIndex,
      required this.onDestinationsSelected});

  @override
  State<NavigationSidebar> createState() => _NavigationSidebarState();
}

class _NavigationSidebarState extends State<NavigationSidebar> {
  var isExtended = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final screenHeight = MediaQuery.sizeOf(context).height;

    return NavigationRail(
      destinations: widget.navigationDestinations,
      trailing: SizedBox(
        height: screenHeight / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              isExtended ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: isExtended
                  ? CapsuleExtendedFloatingActionButton(
                      onPressed: () {},
                      icon: widget.floatingActionButtonDestination.icon,
                      label: Text(widget.floatingActionButtonDestination.label),
                    )
                  : FloatingActionButton(
                      onPressed: () {},
                      shape: CircleBorder(),
                      child: widget.floatingActionButtonDestination.icon,
                    ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 6, end: 6, bottom: 12),
              child: IconButton(
                onPressed: () => setState(() {
                  isExtended = !isExtended;
                }),
                icon: Icon(Icons.menu_open_rounded),
              ),
            ),
          ],
        ),
      ),
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onDestinationsSelected,
      extended: isExtended,
      minExtendedWidth: 175,
      groupAlignment: 1,
      backgroundColor: colorScheme.surfaceContainer,
    );
  }
}
