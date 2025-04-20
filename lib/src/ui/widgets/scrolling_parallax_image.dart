import 'package:flutter/material.dart';

import '../core/global_widget.dart';

class ScrollingParallaxImage extends StatelessWidget {
  final Widget image;
  final double? aspectRatio;

  ScrollingParallaxImage({super.key, required this.image, this.aspectRatio});

  final backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) => Flow(
        delegate: ParallaxFlowDelegate(
          scrollable: Scrollable.of(context),
          listItemContext: context,
          backgroundImageKey: backgroundImageKey,
        ),
        children: [
          aspectRatio == null
              ? GlobalWidget(
                  key: backgroundImageKey,
                  child: image,
                )
              : AspectRatio(
                  key: backgroundImageKey,
                  aspectRatio: aspectRatio!,
                  child: image,
                ),
        ],
      );
}

class ParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  ParallaxFlowDelegate(
      {required this.scrollable,
      required this.listItemContext,
      required this.backgroundImageKey})
      : super(repaint: scrollable.position);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) =>
      BoxConstraints.tightFor(width: constraints.maxWidth);

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    final backgroundBox =
        backgroundImageKey.currentContext!.findRenderObject() as RenderBox;
    final backgroundSize = backgroundBox.size;
    final listItemSize = listItemBox.size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    context.paintChild(
      0,
      transform: Transform.translate(
        offset: Offset(0.0, childRect.top),
      ).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) =>
      scrollable != oldDelegate.scrollable ||
      listItemContext != oldDelegate.listItemContext ||
      backgroundImageKey != oldDelegate.backgroundImageKey;
}
