import 'package:flutter/material.dart';

import '../constants/breakpoint.dart';

/// A built-in layout detection [State].
///
/// There is an extra [breakpoint] property that tells which [Breakpoint] the
/// width of window now is belong to.
mixin AdaptiveState<T extends StatefulWidget> on State<T> {
  var breakpoint = Breakpoint.compact;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final windowWidth = MediaQuery.sizeOf(context).width;

    final currentBreakpoint = Breakpoint.include(windowWidth);
    if (breakpoint != currentBreakpoint) {
      breakpoint = currentBreakpoint;
    }
  }
}
