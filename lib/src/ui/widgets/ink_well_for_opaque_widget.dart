import 'package:flutter/material.dart';

class InkWellForOpaqueWidget extends StatelessWidget {
  final Widget child;
  final InkWell inkWell;

  const InkWellForOpaqueWidget(
      {super.key, required this.inkWell, required this.child});

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          child,
          Material(
            type: MaterialType.transparency,
            child: inkWell,
          ),
        ],
      );
}
