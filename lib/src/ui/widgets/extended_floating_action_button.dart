import 'package:flutter/material.dart';

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
