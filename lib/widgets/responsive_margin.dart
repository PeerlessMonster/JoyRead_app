import 'package:flutter/material.dart';

import '../constants/breakpoint.dart';
import '../constants/layout.dart';
import '../utils/adaptive_state.dart';

class ResponsiveMargin extends StatefulWidget {
  final Widget? child;
  final ResponsiveEdgeInsets margin;

  const ResponsiveMargin({super.key, required this.margin, this.child});

  @override
  State<ResponsiveMargin> createState() => _ResponsiveMarginState();
}

class _ResponsiveMarginState extends AdaptiveState<ResponsiveMargin> {
  @override
  Widget build(BuildContext context) {
    final edgeInsets = switch (breakpoint) {
      Breakpoint.compact => Spacing.compactMargin,
      Breakpoint.medium => Spacing.mediumMargin,
      Breakpoint.expanded => Spacing.expandedMargin,
      Breakpoint.large => Spacing.largeMargin,
      Breakpoint.extraLarge => Spacing.largeMargin
    };

    final bottomMargin = widget.margin.applyBottom ? edgeInsets : .0;
    final horizontalMargin = widget.margin.applyHorizontal ? edgeInsets : .0;
    final topMargin = widget.margin.applyTop ? edgeInsets : .0;
    
    return Padding(
      padding: EdgeInsets.fromLTRB(
          horizontalMargin, topMargin, horizontalMargin, bottomMargin),
      child: widget.child,
    );
  }
}

class ResponsiveEdgeInsets {
  final bool applyBottom;
  final bool applyHorizontal;
  final bool applyTop;

  ResponsiveEdgeInsets.all()
      : applyBottom = true,
        applyHorizontal = true,
        applyTop = true;

  ResponsiveEdgeInsets.symmetric(
      {bool applyVertical = false, this.applyHorizontal = false})
      : applyBottom = applyVertical,
        applyTop = applyVertical;

  ResponsiveEdgeInsets.only(
      {this.applyBottom = false,
      this.applyHorizontal = false,
      this.applyTop = false});
}
