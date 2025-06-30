import 'package:flutter/widgets.dart';

import '../../utils/breakpoint.dart';

/// A widget that constrains the width of child.
///
/// If the available space is larger than [maxWidth], the child will be centered
/// and sized to [maxWidth]. Otherwise, the child will take the full width of
/// the available space.
class MaxWidthBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MaxWidthBox({super.key, required this.maxWidth, required this.child});

  /// Creates a box with a maximum width based on the given [Breakpoint].
  ///
  /// Pass a [Breakpoint] to [endpoint]. The [start] of [screenWidthRange]
  /// property is used to limit size.
  MaxWidthBox.breakpoint(
      {super.key, required Breakpoint endpoint, required this.child})
      : maxWidth = endpoint.screenWidthRange.start;

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          width: maxWidth,
          child: child,
        ),
      );
}
