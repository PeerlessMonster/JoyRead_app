import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../core/pressed_action.dart';
import '../core/themes/constants/dimension.dart' as dimension;
import 'action_bottom_bar.dart';

const _floatingActionButtonShape = CircleBorder();
const _floatingActionButtonLocation = FloatingActionButtonLocation.endDocked;

class NarrowScreenActionScaffold extends StatelessWidget {
  final Widget body;
  final PressedAction floatingAction;
  final List<PressedAction> primaryActions;
  final List<PressedAction> secondaryActions;

  const NarrowScreenActionScaffold(
      {super.key,
      required this.body,
      required this.floatingAction,
      required this.primaryActions,
      required this.secondaryActions});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: body,
        bottomNavigationBar: ActionBottomBar(
          primaryActions: primaryActions,
          secondaryActions: secondaryActions,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: floatingAction.onPressed,
          tooltip: floatingAction.name,
          shape: _floatingActionButtonShape,
          child: floatingAction.icon,
        ),
        floatingActionButtonLocation: _floatingActionButtonLocation,
      );
}

class ScrollingHiddenNarrowScreenActionScaffold extends StatefulWidget {
  final Widget Function(BuildContext context, ScrollController controller)
      bodyBuilder;
  final PressedAction floatingAction;
  final List<PressedAction> primaryActions;
  final List<PressedAction> secondaryActions;
  final double hidingMotionFactor;

  const ScrollingHiddenNarrowScreenActionScaffold(
      {super.key,
      required this.bodyBuilder,
      required this.floatingAction,
      required this.primaryActions,
      required this.secondaryActions,
      this.hidingMotionFactor = 0.5})
      : assert(hidingMotionFactor > 0,
            'Factor of hiding motion should be positive');

  @override
  State<ScrollingHiddenNarrowScreenActionScaffold> createState() =>
      _ScrollingHiddenNarrowScreenActionScaffoldState();
}

class _ScrollingHiddenNarrowScreenActionScaffoldState
    extends State<ScrollingHiddenNarrowScreenActionScaffold> {
  static const _barHeight = dimension.BottomAppBar.height;
  var currentBarHeight = _barHeight;

  var oldScrollOffset = .0;

  void _handleScrollChange() {
    final scrollOffset = _controller.offset;

    switch (_controller.position.userScrollDirection) {
      case ScrollDirection.forward:
        if (currentBarHeight == _barHeight) {
          break;
        }
        setState(() {
          currentBarHeight +=
              widget.hidingMotionFactor * (oldScrollOffset - scrollOffset);
          if (currentBarHeight > _barHeight) {
            currentBarHeight = _barHeight;
          }
        });

      case ScrollDirection.idle:
        break;

      case ScrollDirection.reverse:
        if (currentBarHeight == 0) {
          break;
        }
        setState(() {
          currentBarHeight -=
              widget.hidingMotionFactor * (scrollOffset - oldScrollOffset);
          if (currentBarHeight < 0) {
            currentBarHeight = 0;
          }
        });
    }
    oldScrollOffset = scrollOffset;
  }

  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
    _controller.addListener(_handleScrollChange);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: widget.bodyBuilder(context, _controller),
        bottomNavigationBar: SizedBox(
          height: currentBarHeight,
          child: OverflowBox(
            alignment: Alignment.topCenter,
            minHeight: _barHeight,
            maxHeight: _barHeight,
            child: ActionBottomBar(
              primaryActions: widget.primaryActions,
              secondaryActions: widget.secondaryActions,
            ),
          ),
        ),
        floatingActionButton:
            currentBarHeight >= dimension.BottomAppBar.notchSinkingHeight
                ? FloatingActionButton(
                    onPressed: widget.floatingAction.onPressed,
                    tooltip: widget.floatingAction.name,
                    shape: _floatingActionButtonShape,
                    child: widget.floatingAction.icon,
                  )
                : null,
        floatingActionButtonLocation: _floatingActionButtonLocation,
      );

  @override
  void dispose() {
    _controller.removeListener(_handleScrollChange);

    _controller.dispose();
    super.dispose();
  }
}
