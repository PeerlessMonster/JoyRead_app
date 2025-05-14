import 'dart:async';

import 'package:flutter/material.dart';

import '../core/themes/constants/spacing.dart' as spacing;

class DottedProgressIndicator extends StatefulWidget {
  const DottedProgressIndicator({super.key});

  @override
  State<DottedProgressIndicator> createState() =>
      _DottedProgressIndicatorState();
}

class _DottedProgressIndicatorState extends State<DottedProgressIndicator> {
  static const _dimension = 8.0;

  static const _dotCount = 3;

  var brightDotIndex = 0;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
        const Duration(milliseconds: 500),
        (timer) => setState(() {
              if (++brightDotIndex >= _dotCount) {
                brightDotIndex = 0;
              }
            }));
  }

  late final Timer timer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: spacing.Padding.increment * 1,
      children: List.generate(
        _dotCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          width: _dimension,
          height: _dimension,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == brightDotIndex
                ? colorScheme.primary
                : colorScheme.secondaryContainer,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
