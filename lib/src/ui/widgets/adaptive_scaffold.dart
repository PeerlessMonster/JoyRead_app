import 'package:flutter/material.dart';

import '../../utils/breakpoint.dart';
import '../core/breakpoint_state.dart';

class AnimatedAdaptiveScaffold extends StatefulWidget {
  final Widget body;
  final Widget wideScreenSidebar;
  final Widget narrowScreenBottomBar;
  final Widget? narrowScreenFloatingActionButton;
  final FloatingActionButtonLocation? narrowScreenFloatingActionButtonLocation;
  final Duration duration;

  const AnimatedAdaptiveScaffold(
      {super.key,
      required this.body,
      required this.wideScreenSidebar,
      required this.narrowScreenBottomBar,
      this.narrowScreenFloatingActionButton,
      this.narrowScreenFloatingActionButtonLocation,
      this.duration = const Duration(milliseconds: 300)});

  @override
  State<AnimatedAdaptiveScaffold> createState() =>
      _AnimatedAdaptiveScaffoldState();
}

class _AnimatedAdaptiveScaffoldState extends State<AnimatedAdaptiveScaffold> {
  var isWideScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final breakpoint = dependOnWindowWidth(context);
    if (breakpoint <= Breakpoint.compact) {
      if (isWideScreen != false) {
        setState(() {
          isWideScreen = false;
        });
      }
    } else {
      if (isWideScreen != true) {
        setState(() {
          isWideScreen = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(children: [
          AnimatedAlign(
            duration: widget.duration,
            alignment: AlignmentDirectional.centerEnd,
            widthFactor: isWideScreen ? 1 : 0,
            child: widget.wideScreenSidebar,
          ),
          Expanded(
            child: SafeArea(
              child: widget.body,
            ),
          ),
        ]),
        bottomNavigationBar: AnimatedAlign(
          duration: widget.duration,
          alignment: Alignment.topCenter,
          heightFactor: isWideScreen ? 0 : 1,
          child: widget.narrowScreenBottomBar,
        ),
        floatingActionButton:
            isWideScreen ? null : widget.narrowScreenFloatingActionButton,
        floatingActionButtonLocation:
            widget.narrowScreenFloatingActionButtonLocation,
      );
}
