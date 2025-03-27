import 'package:flutter/material.dart';

import '../../utils/breakpoint.dart';
import 'breakpoint_state.dart';
import 'themes/constants/spacing.dart' as spacing;

EdgeInsetsGeometry _buildMargin(
    BuildContext context, ResponsiveEdgeInsets responsiveMargin) {
  final edgeInsets = calculateResponsiveMarginValue(context);

  final startMargin = responsiveMargin.enableStart ? edgeInsets : .0;
  final topMargin = responsiveMargin.enableTop ? edgeInsets : .0;
  final endMargin = responsiveMargin.enableEnd ? edgeInsets : .0;
  final bottomMargin = responsiveMargin.enableBottom ? edgeInsets : .0;
  return EdgeInsetsDirectional.only(
      start: startMargin, top: topMargin, end: endMargin, bottom: bottomMargin);
}

/// Detect layout and apply margin automatically.
///
/// Equivalent to [Padding].
///
/// See also:
///
///   * [ResponsiveEdgeInsets]
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
    final margin = _buildMargin(context, widget.margin);
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
/// See also:
///
///   * [ResponsiveEdgeInsets]
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
    final margin = _buildMargin(context, widget.margin);
    return SliverPadding(
      padding: margin,
      sliver: widget.sliver,
    );
  }
}

/// The [margin] parameter of the constructor of [ResponsiveMargin] and
/// [ResponsiveSliverMargin].
///
/// Equivalent to [EdgeInsets].
class ResponsiveEdgeInsets {
  final bool enableStart;
  final bool enableTop;
  final bool enableEnd;
  final bool enableBottom;

  const ResponsiveEdgeInsets.all()
      : enableStart = true,
        enableTop = true,
        enableEnd = true,
        enableBottom = true;

  const ResponsiveEdgeInsets.fromSTEB(
      this.enableStart, this.enableTop, this.enableEnd, this.enableBottom);

  const ResponsiveEdgeInsets.only(
      {this.enableStart = false,
      this.enableTop = false,
      this.enableEnd = false,
      this.enableBottom = false});

  const ResponsiveEdgeInsets.symmetric(
      {bool enableHorizontal = false, bool enableVertical = false})
      : enableStart = enableHorizontal,
        enableTop = enableVertical,
        enableEnd = enableHorizontal,
        enableBottom = enableVertical;
}

/// Calculate current value of margin according to [Breakpoint].
double calculateResponsiveMarginValue(BuildContext context) {
  final breakpoint = BreakpointState.maybeOf(context) ?? Breakpoint.compact;
  return switch (breakpoint) {
    Breakpoint.compact => spacing.Margin.compactMargin,
    Breakpoint.medium => spacing.Margin.mediumMargin,
    Breakpoint.expanded => spacing.Margin.expandedMargin,
    Breakpoint.large => spacing.Margin.largeMargin,
    Breakpoint.extraLarge => spacing.Margin.largeMargin,
  };
}
