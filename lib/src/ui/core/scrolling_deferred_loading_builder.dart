import 'package:flutter/material.dart';

/// A builder defers loading while scrolling.
///
/// [independentChild] is passed to the [childBuilder] parameter of the constructor of
/// [ValueListenableBuilder].
class ScrollingDeferredLoadingBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, Widget? child) underwayBuilder;
  final Widget Function(BuildContext context, Widget? child) idleBuilder;
  final Widget? independentChild;

  const ScrollingDeferredLoadingBuilder(
      {super.key,
      required this.underwayBuilder,
      required this.idleBuilder,
      this.independentChild});

  @override
  State<ScrollingDeferredLoadingBuilder> createState() =>
      _ScrollingDeferredLoadingBuilderState();
}

class _ScrollingDeferredLoadingBuilderState
    extends State<ScrollingDeferredLoadingBuilder> {
  var isCompleted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final scrollable = Scrollable.of(context);
    _isScrollingNotifier = scrollable.position.isScrollingNotifier;
  }

  late final ValueNotifier _isScrollingNotifier;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: _isScrollingNotifier,
        builder: (context, isScrolling, child) {
          if (isScrolling && !isCompleted) {
            return widget.underwayBuilder(context, child);
          }
          isCompleted = true;

          return widget.idleBuilder(context, child);
        },
        child: widget.independentChild,
      );
}
