import 'package:flutter/material.dart';

import '../../utils/breakpoint.dart';
import 'breakpoint_state.dart';
import 'themes/constants/spacing.dart' as spacing;

/// The [margin] parameter of the constructor of [ResponsiveMargin] and
/// [ResponsiveSliverMargin].
///
/// Equivalent to [EdgeInsets].
class ResponsiveEdgeInsets {
  final bool applyStart;
  final bool applyTop;
  final bool applyEnd;
  final bool applyBottom;

  const ResponsiveEdgeInsets.all()
      : applyStart = true,
        applyTop = true,
        applyEnd = true,
        applyBottom = true;

  const ResponsiveEdgeInsets.fromSTEB(
      this.applyStart, this.applyTop, this.applyEnd, this.applyBottom);

  const ResponsiveEdgeInsets.only(
      {this.applyStart = false,
      this.applyTop = false,
      this.applyEnd = false,
      this.applyBottom = false});

  const ResponsiveEdgeInsets.symmetric(
      {bool applyHorizontal = false, bool applyVertical = false})
      : applyStart = applyHorizontal,
        applyTop = applyVertical,
        applyEnd = applyHorizontal,
        applyBottom = applyVertical;
}

/// Detect layout and apply margin automatically.
///
/// Equivalent to [Padding].
///
/// See also [ResponsiveEdgeInsets].
class ResponsiveMargin extends StatefulWidget {
  final Widget? child;
  final ResponsiveEdgeInsets margin;

  const ResponsiveMargin({super.key, required this.margin, this.child});

  @override
  State<ResponsiveMargin> createState() => _ResponsiveMarginState();
}

class _ResponsiveMarginState extends State<ResponsiveMargin> {
  @override
  Widget build(BuildContext context) {
    final breakpoint = BreakpointState.maybeOf(context) ?? Breakpoint.compact;
    final margin = _calculateMargin(widget.margin, breakpoint);
    return Padding(
      padding: margin,
      child: widget.child,
    );
  }
}

/// Detect layout and apply margin automatically.
///
/// Equivalent to [SliverPadding].
///
/// See also [ResponsiveEdgeInsets].
class ResponsiveSliverMargin extends StatefulWidget {
  final Widget? sliver;
  final ResponsiveEdgeInsets margin;

  const ResponsiveSliverMargin({super.key, required this.margin, this.sliver});

  @override
  State<ResponsiveSliverMargin> createState() => _ResponsiveSliverMarginState();
}

class _ResponsiveSliverMarginState extends State<ResponsiveSliverMargin> {
  @override
  Widget build(BuildContext context) {
    final breakpoint = BreakpointState.maybeOf(context) ?? Breakpoint.compact;
    final margin = _calculateMargin(widget.margin, breakpoint);
    return SliverPadding(
      padding: margin,
      sliver: widget.sliver,
    );
  }
}

EdgeInsetsGeometry _calculateMargin(
    ResponsiveEdgeInsets responsiveMargin, Breakpoint breakpoint) {
  final edgeInsets = switch (breakpoint) {
    Breakpoint.compact => spacing.Margin.compactMargin,
    Breakpoint.medium => spacing.Margin.mediumMargin,
    Breakpoint.expanded => spacing.Margin.expandedMargin,
    Breakpoint.large => spacing.Margin.largeMargin,
    Breakpoint.extraLarge => spacing.Margin.largeMargin
  };

  final startMargin = responsiveMargin.applyStart ? edgeInsets : .0;
  final topMargin = responsiveMargin.applyTop ? edgeInsets : .0;
  final endMargin = responsiveMargin.applyEnd ? edgeInsets : .0;
  final bottomMargin = responsiveMargin.applyBottom ? edgeInsets : .0;
  return EdgeInsetsDirectional.only(
      start: startMargin, top: topMargin, end: endMargin, bottom: bottomMargin);
}
