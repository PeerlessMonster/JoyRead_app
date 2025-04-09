// refer to Material Design 3 standard
// https://m3.material.io/foundations/layout/applying-layout/window-size-classes#2bb70e22-d09b-4b73-9c9f-9ef60311ccc8

import 'package:flutter/material.dart';

enum Breakpoint {
  /// Phone in portrait
  compact(screenWidthRange: RangeValues(0, 599)),

  /// Tablet in portrait
  /// Foldable in portrait (unfolded)
  medium(screenWidthRange: RangeValues(600, 839)),

  /// Phone in landscape
  /// Tablet in landscape
  /// Foldable in landscape (unfolded)
  /// Desktop
  expanded(screenWidthRange: RangeValues(840, 1199)),

  /// Desktop
  large(screenWidthRange: RangeValues(1200, 1599)),

  /// Desktop
  /// Ultra-wide
  extraLarge(screenWidthRange: RangeValues(1600, double.infinity));

  final RangeValues screenWidthRange;

  const Breakpoint({required this.screenWidthRange});

  /// Construct a [Breakpoint] that the given [screenWidth] belongs to.
  factory Breakpoint.include(double screenWidth) {
    assert(screenWidth >= 0, 'Width of window should be positive');

    if (screenWidth >= 1600) {
      return Breakpoint.extraLarge;
    } else if (screenWidth >= 1200) {
      return Breakpoint.large;
    } else if (screenWidth >= 840) {
      return Breakpoint.expanded;
    } else if (screenWidth >= 600) {
      return Breakpoint.medium;
    } else {
      return Breakpoint.compact;
    }
  }

  bool operator >(Breakpoint breakpoint) =>
      screenWidthRange.start > breakpoint.screenWidthRange.end;

  bool operator <(Breakpoint breakpoint) =>
      screenWidthRange.end < breakpoint.screenWidthRange.start;

  bool operator >=(Breakpoint breakpoint) =>
      screenWidthRange.start >= breakpoint.screenWidthRange.start;

  bool operator <=(Breakpoint breakpoint) =>
      screenWidthRange.end <= breakpoint.screenWidthRange.end;
}
