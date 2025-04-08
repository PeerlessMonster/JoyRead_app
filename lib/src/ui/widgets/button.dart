import 'package:flutter/material.dart';

import '../core/themes/constants/style.dart';

class ElevatedRoundedRectangleIconButton extends StatelessWidget {
  final Widget? icon;
  final Widget label;
  final void Function() onPressed;

  const ElevatedRoundedRectangleIconButton(
      {super.key, this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        iconColor: colorScheme.onSecondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
        backgroundColor: colorScheme.secondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              RoundedCorner.slidingSegmentedControlBorderRadius),
        ),
      ),
      icon: icon,
      label: label,
      onPressed: onPressed,
    );
  }
}

class CapsuleExtendedFloatingActionButton extends StatelessWidget {
  final Widget icon;
  final Widget label;
  final void Function() onPressed;

  const CapsuleExtendedFloatingActionButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
        onPressed: onPressed,
        shape: StadiumBorder(),
        icon: icon,
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: label,
        ),
      );
}
