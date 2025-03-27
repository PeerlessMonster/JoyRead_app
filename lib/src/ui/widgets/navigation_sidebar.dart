import 'package:flutter/material.dart';

import '../core/page_navigation_destination.dart';
import '../core/pressed_action.dart';
import '../core/themes/constants/dimension.dart' as dimension;
import '../core/themes/constants/spacing.dart' as spacing;
import 'extended_floating_action_button.dart';

class NavigationSidebar extends StatefulWidget {
  final List<PageNavigationDestination> navigationDestinations;
  final PressedAction floatingAction;
  final int selectedIndex;
  final void Function(int) onDestinationsSelected;

  const NavigationSidebar(
      {super.key,
      required this.navigationDestinations,
      required this.floatingAction,
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
      destinations: widget.navigationDestinations
          .map((destination) => NavigationRailDestination(
                icon: destination.icon,
                label: Text(destination.name),
              ))
          .toList(),
      trailing: SizedBox(
        height: screenHeight / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              isExtended ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: spacing.Padding.targetSpacing),
              child: isExtended
                  ? CapsuleExtendedFloatingActionButton(
                      onPressed: () {},
                      icon: widget.floatingAction.icon,
                      label: Text(widget.floatingAction.name),
                    )
                  : FloatingActionButton(
                      onPressed: () {},
                      shape: CircleBorder(),
                      child: widget.floatingAction.icon,
                    ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: dimension.NavigationRail.horizontalPadding,
                  end: dimension.NavigationRail.horizontalPadding,
                  bottom: dimension.NavigationRail.verticalPadding),
              child: IconButton(
                tooltip: 'Expand',
                icon: Icon(Icons.menu_open_rounded),
                onPressed: () => setState(() {
                  isExtended = !isExtended;
                }),
              ),
            ),
          ],
        ),
      ),
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onDestinationsSelected,
      extended: isExtended,
      minExtendedWidth: dimension.NavigationRail.extendedWidth,
      groupAlignment: 1,
      backgroundColor: colorScheme.surfaceContainer,
    );
  }
}
