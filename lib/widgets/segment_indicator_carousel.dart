import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../constants/layout.dart';

class SegmentIndicatorCarousel extends StatefulWidget {
  final List<Widget> children;
  final bool autoplay;
  final bool isInfiniteLoop;
  final bool showIndicator;
  final double maxImageHeight;

  const SegmentIndicatorCarousel(
      {super.key,
      required this.maxImageHeight,
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
  var _currentSegmentIndex = 0;

  static const _spacing = Spacing.paddingIncrement * 3;

  late final SwiperController _controller;

  @override
  void initState() {
    _controller = SwiperController();
    super.initState();
  }

  Widget _buildCarousel() => LimitedBox(
        maxHeight: widget.maxImageHeight,
        child: Swiper(
          loop: widget.isInfiniteLoop,
          itemBuilder: (context, index) => widget.children[index],
          itemCount: widget.children.length,
          viewportFraction: 0.6,
          scale: 0.9,
          onIndexChanged: (index) => setState(() {
            _currentSegmentIndex = index;
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
          LimitedBox(
            maxHeight: 20,
            child: SegmentedButton<int>(
              segments: List.generate(
                widget.children.length,
                (index) => ButtonSegment(
                  value: index,
                  label: SizedBox.shrink(),
                ),
              ),
              showSelectedIcon: false,
              selected: {_currentSegmentIndex},
              onSelectionChanged: (newSelections) {
                final newSegmentIndex = newSelections.first;
                _controller.move(newSegmentIndex);

                setState(() {
                  _currentSegmentIndex = newSegmentIndex;
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
