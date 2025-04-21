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
  final Object? heroTag;
  static const _shape = StadiumBorder();

  const CapsuleExtendedFloatingActionButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed,
      this.heroTag});

  Widget _buildLabel() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: label,
      );

  @override
  Widget build(BuildContext context) => heroTag == null
      ? FloatingActionButton.extended(
          onPressed: onPressed,
          shape: _shape,
          icon: icon,
          label: label,
        )
      : FloatingActionButton.extended(
          onPressed: onPressed,
          heroTag: heroTag,
          shape: _shape,
          icon: icon,
          label: _buildLabel(),
        );
}
