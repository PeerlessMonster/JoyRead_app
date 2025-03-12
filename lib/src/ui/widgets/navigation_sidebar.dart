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
  late final _colorScheme = Theme.of(context).colorScheme;

  var isExtended = false;

  late double _windowHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _windowHeight = MediaQuery.sizeOf(context).height;
  }

  @override
  Widget build(BuildContext context) => NavigationRail(
        destinations: widget.navigationDestinations,
        trailing: SizedBox(
          height: _windowHeight / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: isExtended
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: isExtended
                    ? CapsuleExtendedFloatingActionButton(
                        onPressed: () {},
                        icon: widget.floatingActionButtonDestination.icon,
                        label:
                            Text(widget.floatingActionButtonDestination.label),
                      )
                    : FloatingActionButton(
                        onPressed: () {},
                        shape: CircleBorder(),
                        child: widget.floatingActionButtonDestination.icon,
                      ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.only(start: 6, end: 6, bottom: 12),
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
        backgroundColor: _colorScheme.surfaceContainer,
      );
}
