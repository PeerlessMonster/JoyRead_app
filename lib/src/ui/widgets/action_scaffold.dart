import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../core/pressed_action.dart';
import '../core/themes/constants/animation.dart';
import '../core/themes/constants/dimension.dart' as dimension;
import 'action_bottom_bar.dart';
import 'action_sidebar.dart';
import 'adaptive_scaffold.dart';

class ActionScaffold extends StatefulWidget {
  final Widget Function(BuildContext context, ScrollController controller)
      bodyBuilder;
  final PressedAction floatingAction;
  final List<PressedAction> primaryActions;
  final List<PressedAction> secondaryActions;

  const ActionScaffold(
      {super.key,
      required this.bodyBuilder,
      required this.floatingAction,
      required this.primaryActions,
      required this.secondaryActions});

  @override
  State<ActionScaffold> createState() => _ActionScaffoldState();
}

class _ActionScaffoldState extends State<ActionScaffold> {
  static const _bottomBarHeight = dimension.BottomAppBar.height;
  var currentBottomBarHeight = _bottomBarHeight;

  static const _hidingMotionFactor = 0.5;

  var _oldScrollOffset = .0;

  void _handleScrollChange() {
    final scrollOffset = _controller.offset;

    switch (_controller.position.userScrollDirection) {
      case ScrollDirection.forward:
        if (currentBottomBarHeight == _bottomBarHeight) {
          break;
        }
        setState(() {
          currentBottomBarHeight +=
              _hidingMotionFactor * (_oldScrollOffset - scrollOffset);
          if (currentBottomBarHeight > _bottomBarHeight) {
            currentBottomBarHeight = _bottomBarHeight;
          }
        });

      case ScrollDirection.idle:
        break;

      case ScrollDirection.reverse:
        if (currentBottomBarHeight == 0) {
          break;
        }
        setState(() {
          currentBottomBarHeight -=
              _hidingMotionFactor * (scrollOffset - _oldScrollOffset);
          if (currentBottomBarHeight < 0) {
            currentBottomBarHeight = 0;
          }
        });
    }
    _oldScrollOffset = scrollOffset;
  }

  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
    _controller.addListener(_handleScrollChange);
  }

  @override
  Widget build(BuildContext context) => AnimatedAdaptiveScaffold(
        body: widget.bodyBuilder(context, _controller),
        wideScreenSidebar: ActionSidebar(
          floatingAction: widget.floatingAction,
          primaryActions: widget.primaryActions,
          secondaryActions: widget.secondaryActions,
        ),
        narrowScreenBottomBar: Align(
          alignment: Alignment.topCenter,
          heightFactor: currentBottomBarHeight / _bottomBarHeight,
          child: ActionBottomBar(
            primaryActions: widget.primaryActions,
            secondaryActions: widget.secondaryActions,
          ),
        ),
        narrowScreenFloatingActionButton:
            currentBottomBarHeight >= _bottomBarHeight / 3
                ? FloatingActionButton(
                    onPressed: widget.floatingAction.onPressed,
                    heroTag: HeroTag.scaffoldFloatingActionButton,
                    tooltip: widget.floatingAction.name,
                    shape: const CircleBorder(),
                    child: widget.floatingAction.icon,
                  )
                : null,
        narrowScreenFloatingActionButtonLocation:
            FloatingActionButtonLocation.endDocked,
      );

  @override
  void dispose() {
    _controller.removeListener(_handleScrollChange);

    _controller.dispose();
    super.dispose();
  }
}
