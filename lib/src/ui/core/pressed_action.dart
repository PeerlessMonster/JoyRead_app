import 'package:flutter/material.dart';

/// Data class of action.
///
/// Can be used by some of the widgets include:
///
///   * [IconButton]
///   * [FloatingActionButton]
class PressedAction {
  final String name;
  final Icon icon;
  final void Function() onPressed;

  const PressedAction(
      {required this.name, required this.icon, required this.onPressed});
}
