import 'package:flutter/material.dart';

import '../../utils/breakpoint.dart';

/// A built-in width of screen detection [LayoutBuilder]
///
/// If [Breakpoint.compact] includes current width of screen,
/// [narrowScreenWidget] will be built. Otherwise, [wideScreenWidget] will be
/// built.
class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget narrowScreenWidget;
  final Widget wideScreenWidget;

  const ResponsiveLayoutBuilder(
      {super.key,
      required this.narrowScreenWidget,
      required this.wideScreenWidget});

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final breakpoint = Breakpoint.include(screenWidth);
        return breakpoint <= Breakpoint.compact
            ? narrowScreenWidget
            : wideScreenWidget;
      });
}
