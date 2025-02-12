// refer to Material Design 3 standard
// https://m3.material.io/foundations/layout/applying-layout/window-size-classes#2bb70e22-d09b-4b73-9c9f-9ef60311ccc8

import 'package:flutter/material.dart';

enum Breakpoint {
  /// Phone in portrait
  compact(windowWidth: RangeValues(0, 599)),

  /// Tablet in portrait
  /// Foldable in portrait (unfolded)
  medium(windowWidth: RangeValues(600, 839)),

  /// Phone in landscape
  /// Tablet in landscape
  /// Foldable in landscape (unfolded)
  /// Desktop
  expanded(windowWidth: RangeValues(840, 1199)),

  /// Desktop
  large(windowWidth: RangeValues(1200, 1599)),

  /// Desktop
  /// Ultra-wide
  extraLarge(windowWidth: RangeValues(1600, double.infinity));

  final RangeValues windowWidth;

  const Breakpoint({required this.windowWidth});

  /// Construct a [Breakpoint] that the given [windowWidth] belongs to.
  factory Breakpoint.include(double windowWidth) => switch (windowWidth) {
        >= 0 && < 600 => Breakpoint.compact,
        >= 600 && < 840 => Breakpoint.medium,
        >= 840 && < 1200 => Breakpoint.expanded,
        >= 1200 && < 1600 => Breakpoint.large,
        >= 1600 => Breakpoint.extraLarge,
        _ => throw RangeError.range(windowWidth, 0, null)
      };

  bool operator >(Breakpoint breakpoint) =>
      windowWidth.start > breakpoint.windowWidth.end;

  bool operator <(Breakpoint breakpoint) =>
      windowWidth.end < breakpoint.windowWidth.start;

  bool operator >=(Breakpoint breakpoint) =>
      windowWidth.start >= breakpoint.windowWidth.start;

  bool operator <=(Breakpoint breakpoint) =>
      windowWidth.end <= breakpoint.windowWidth.end;
}
