import 'package:flutter/widgets.dart';

import '../../utils/breakpoint.dart';

/// A box that constrains the width of child.
///
/// Pass a [Breakpoint] to [endpoint]. The [start] of [screenWidthRange]
/// property is used to limit size. If available space is over [maxWidth], the
/// child will be centered.
class MaxWidthBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  MaxWidthBox({super.key, required Breakpoint endpoint, required this.child})
      : maxWidth = endpoint.screenWidthRange.start;

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          width: maxWidth,
          child: child,
        ),
      );
}
