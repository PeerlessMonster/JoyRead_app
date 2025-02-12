import 'package:flutter/material.dart';

import 'capsule_extended_floating_action_button.dart';

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

  var _isExtended = false;

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
            crossAxisAlignment: _isExtended
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _isExtended
                    ? ExtendedFloatingActionButton(
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
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                child: IconButton(
                  onPressed: () => setState(() {
                    _isExtended = !_isExtended;
                  }),
                  icon: Icon(Icons.menu_open_rounded),
                ),
              ),
            ],
          ),
        ),
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: widget.onDestinationsSelected,
        extended: _isExtended,
        minExtendedWidth: 175,
        groupAlignment: 1,
        backgroundColor: _colorScheme.surfaceContainer,
      );
}
