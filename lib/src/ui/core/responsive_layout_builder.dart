import 'package:flutter/material.dart';

import '../../utils/breakpoint.dart';

/// A built-in screen width detection [LayoutBuilder].
///
/// This widget uses [Breakpoint] to determine the size category of its
/// available space, then provides a builder function with a boolean flag
/// indicating whether it is wide-screen.
class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, bool isWideScreen) builder;

  const ResponsiveLayoutBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final breakpoint = Breakpoint.include(screenWidth);
        return builder(context, breakpoint.isWideScreen);
      });
}
