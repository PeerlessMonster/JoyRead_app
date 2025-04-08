import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlidingSegmentedControl<T extends Object> extends StatelessWidget {
  final Map<T, String> segmentsText;
  final T selectedSegment;
  final void Function(T selection) onSegmentChanged;

  const SlidingSegmentedControl(
      {super.key,
      required this.segmentsText,
      required this.selectedSegment,
      required this.onSegmentChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CupertinoSlidingSegmentedControl<T>(
      thumbColor: colorScheme.secondaryContainer,
      children: segmentsText.map((segment, text) => MapEntry(
            segment,
            Text(
              text,
              style: TextStyle(
                color: colorScheme.onSecondaryContainer,
              ),
            ),
          )),
      groupValue: selectedSegment,
      onValueChanged: (value) {
        if (value != null) {
          onSegmentChanged(value);
        }
      },
    );
  }
}
