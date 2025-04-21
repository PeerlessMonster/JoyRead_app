import 'package:flutter/material.dart';

import '../../utils/breakpoint.dart';

/// Propagate [Breakpoint] information down the widget tree.
///
/// Equivalent to [InheritedWidget].
class BreakpointState extends InheritedWidget {
  final Breakpoint breakpoint;

  const BreakpointState(
      {super.key, required this.breakpoint, required super.child});

  static Breakpoint? maybeOf(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<BreakpointState>();
    return widget?.breakpoint;
  }

  static Breakpoint of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No BreakpointState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(BreakpointState oldWidget) =>
      breakpoint != oldWidget.breakpoint;
}

Breakpoint dependOnWindowWidth(BuildContext context) {
  final windowWidth = MediaQuery.sizeOf(context).width;
  return Breakpoint.include(windowWidth);
}

/// A wrapper of [BreakpointState].
///
/// To obtain [Breakpoint] information, insert it to somewhere top of the widget
/// tree. Had better use in [Scaffold] for better performance.
///
/// See also:
///
///   * [BreakpointState]
class BreakpointProvider extends StatelessWidget {
  final Widget child;

  const BreakpointProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final breakpoint = dependOnWindowWidth(context);
    return BreakpointState(
      breakpoint: breakpoint,
      child: child,
    );
  }
}
