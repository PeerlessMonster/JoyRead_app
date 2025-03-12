import 'package:flutter/material.dart';

import '../../utils/breakpoint.dart';
import 'breakpoint_state.dart';
import 'themes/constants/layout.dart';

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

class _ResponsiveMarginState
    extends _ResponsiveEdgeInsetsState<ResponsiveMargin> {
  @override
  Widget build(BuildContext context) {
    final margin = _calculateMargin(widget.margin, edgeInsets);
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

class _ResponsiveSliverMarginState
    extends _ResponsiveEdgeInsetsState<ResponsiveSliverMargin> {
  @override
  Widget build(BuildContext context) {
    final margin = _calculateMargin(widget.margin, edgeInsets);
    return SliverPadding(
      padding: margin,
      sliver: widget.sliver,
    );
  }
}

abstract class _ResponsiveEdgeInsetsState<T extends StatefulWidget>
    extends State<T> with BreakpointState<T> {
  var edgeInsets = Spacing.compactMargin;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentEdgeInsets = switch (breakpoint) {
      Breakpoint.compact => Spacing.compactMargin,
      Breakpoint.medium => Spacing.mediumMargin,
      Breakpoint.expanded => Spacing.expandedMargin,
      Breakpoint.large => Spacing.largeMargin,
      Breakpoint.extraLarge => Spacing.largeMargin
    };
    if (currentEdgeInsets != edgeInsets) {
      edgeInsets = currentEdgeInsets;
    }
  }
}

EdgeInsetsGeometry _calculateMargin(
    ResponsiveEdgeInsets responsiveMargin, double edgeInsets) {
  final startMargin = responsiveMargin.applyStart ? edgeInsets : .0;
  final topMargin = responsiveMargin.applyTop ? edgeInsets : .0;
  final endMargin = responsiveMargin.applyEnd ? edgeInsets : .0;
  final bottomMargin = responsiveMargin.applyBottom ? edgeInsets : .0;
  return EdgeInsetsDirectional.only(
      start: startMargin, top: topMargin, end: endMargin, bottom: bottomMargin);
}
