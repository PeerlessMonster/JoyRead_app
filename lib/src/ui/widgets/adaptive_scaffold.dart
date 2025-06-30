import 'package:flutter/material.dart';

import '../core/responsive_layout_builder.dart';

class AnimatedAdaptiveScaffold extends StatelessWidget {
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
  Widget build(BuildContext context) => ResponsiveLayoutBuilder(
        builder: (context, isWideScreen) => Scaffold(
          body: Row(children: [
            AnimatedAlign(
              duration: duration,
              alignment: AlignmentDirectional.centerEnd,
              widthFactor: isWideScreen ? 1 : 0,
              child: wideScreenSidebar,
            ),
            Expanded(
              child: SafeArea(child: body),
            ),
          ]),
          bottomNavigationBar: AnimatedAlign(
            duration: duration,
            alignment: Alignment.topCenter,
            heightFactor: isWideScreen ? 0 : 1,
            child: narrowScreenBottomBar,
          ),
          floatingActionButton:
              isWideScreen ? null : narrowScreenFloatingActionButton,
          floatingActionButtonLocation:
              narrowScreenFloatingActionButtonLocation,
        ),
      );
}
