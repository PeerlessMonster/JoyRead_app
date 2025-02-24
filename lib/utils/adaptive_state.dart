import 'package:flutter/material.dart';

import '../constants/breakpoint.dart';

/// A built-in layout detection [State].
///
/// Replace (e.g.) `class _MyStatefulWidgetState extends State<MyStatefulWidget> { ... }`
/// to `class _MyStatefulWidgetState extends AdaptiveState<MyStatefulWidget> { ... }`, and
/// there is an extra [breakpoint] getter that returns which [Breakpoint] the width of
/// window now is belong to.
abstract class AdaptiveState<T extends StatefulWidget> extends State<T> {
  var _breakpoint = Breakpoint.compact;

  Breakpoint get breakpoint => _breakpoint;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final windowWidth = MediaQuery.sizeOf(context).width;
    if (_breakpoint != Breakpoint.include(windowWidth)) {
      _breakpoint = Breakpoint.include(windowWidth);
    }
  }
}
