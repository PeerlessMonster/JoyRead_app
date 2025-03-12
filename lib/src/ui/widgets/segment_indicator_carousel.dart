import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../core/themes/constants/layout.dart';

class SegmentIndicatorCarousel extends StatefulWidget {
  final List<Widget> children;
  final bool autoplay;
  final bool isInfiniteLoop;
  final bool showIndicator;
  final double maxCarouselHeight;

  const SegmentIndicatorCarousel(
      {super.key,
      required this.maxCarouselHeight,
      this.showIndicator = true,
      this.isInfiniteLoop = true,
      this.autoplay = true,
      required this.children})
      : assert((autoplay && isInfiniteLoop) || !autoplay,
            "Autoplay requires an infinite loop carousel");

  @override
  State<SegmentIndicatorCarousel> createState() =>
      _SegmentIndicatorCarouselState();
}

class _SegmentIndicatorCarouselState extends State<SegmentIndicatorCarousel> {
  var currentSegmentIndex = 0;

  static const _spacing = Spacing.paddingIncrement * 3;

  late final SwiperController _controller;

  @override
  void initState() {
    _controller = SwiperController();
    super.initState();
  }

  Widget _buildCarousel() => LimitedBox(
        maxHeight: widget.maxCarouselHeight,
        child: Swiper(
          loop: widget.isInfiniteLoop,
          itemBuilder: (context, index) => widget.children[index],
          itemCount: widget.children.length,
          viewportFraction: 0.6,
          scale: 0.9,
          onIndexChanged: (index) => setState(() {
            currentSegmentIndex = index;
          }),
          controller: _controller,
          autoplay: widget.autoplay,
          autoplayDelay: Duration(seconds: 5).inMilliseconds,
        ),
      );

  @override
  Widget build(BuildContext context) => widget.showIndicator
      ? Column(children: [
          _buildCarousel(),
          SizedBox(height: _spacing),
          SizedBox(
            height: 20,
            child: SegmentedButton<int>(
              segments: List.generate(
                widget.children.length,
                (index) => ButtonSegment(
                  value: index,
                  label: SizedBox.shrink(),
                ),
              ),
              showSelectedIcon: false,
              selected: {currentSegmentIndex},
              onSelectionChanged: (newSelections) {
                final newSegmentIndex = newSelections.first;
                _controller.move(newSegmentIndex);

                setState(() {
                  currentSegmentIndex = newSegmentIndex;
                });
              },
            ),
          ),
        ])
      : _buildCarousel();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
