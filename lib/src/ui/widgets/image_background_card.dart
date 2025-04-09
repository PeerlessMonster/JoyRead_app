import 'package:flutter/material.dart';

import '../core/themes/constants/spacing.dart' as spacing;
import 'black_gradient_transparent_box.dart';
import 'skeleton.dart';
import 'translucent_black_box.dart';

class ImageBackgroundCardWithSinkingTitle extends StatefulWidget {
  final String title;
  final Widget backgroundImage;
  final double borderRadius;

  const ImageBackgroundCardWithSinkingTitle(
      {super.key,
      required this.title,
      required this.backgroundImage,
      this.borderRadius = 0});

  @override
  State<ImageBackgroundCardWithSinkingTitle> createState() =>
      _ImageBackgroundCardWithSinkingTitleState();
}

class _ImageBackgroundCardWithSinkingTitleState
    extends State<ImageBackgroundCardWithSinkingTitle> {
  final _key = GlobalKey();
  final _textKey = GlobalKey();

  double? _calculateOffsetFraction() {
    if (_key.currentContext == null) {
      return null;
    }
    final ancestorBox = _key.currentContext!.findRenderObject() as RenderBox;

    final textBox = _textKey.currentContext!.findRenderObject() as RenderBox;
    final textOffset = textBox.localToGlobal(
      textBox.size.topCenter(Offset.zero),
      ancestor: ancestorBox,
    );

    final ancestorHeight = ancestorBox.size.height;
    return textOffset.dy / ancestorHeight;
  }

  double get beginStop => endStop - 0.2;
  var endStop = 0.8;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = textTheme.titleMedium?.copyWith(
      color: Colors.white,
    );

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final offsetFraction = _calculateOffsetFraction();
      if (offsetFraction != null && offsetFraction != endStop) {
        setState(() {
          endStop = offsetFraction;
        });
      }
    });

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: BottomBlackGradientTransparentBox(
        key: _key,
        beginStop: beginStop,
        endStop: endStop,
        image: widget.backgroundImage,
        child: Padding(
          padding: const EdgeInsets.all(spacing.Padding.increment * 5),
          child: Text(
            widget.title,
            key: _textKey,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

class ImageBackgroundCardWithSpaceBetweenTitleAndLabel extends StatelessWidget {
  final String title;
  final String label;
  final Widget backgroundImage;
  final double borderRadius;
  static const _titleTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const _labelTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

  const ImageBackgroundCardWithSpaceBetweenTitleAndLabel(
      {super.key,
      required this.title,
      required this.label,
      required this.backgroundImage,
      this.borderRadius = 0});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: TranslucentBlackBox(
          image: backgroundImage,
          child: Padding(
            padding: const EdgeInsets.all(spacing.Padding.increment * 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _titleTextStyle,
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _labelTextStyle,
                ),
              ],
            ),
          ),
        ),
      );
}

class ImageBackgroundCardSkeleton extends StatelessWidget {
  final bool isLoading;
  final double borderRadius;

  const ImageBackgroundCardSkeleton(
      {super.key, required this.isLoading, this.borderRadius = 0});

  @override
  Widget build(BuildContext context) => BoxSkeleton(
        borderRadius: borderRadius,
      );
}
