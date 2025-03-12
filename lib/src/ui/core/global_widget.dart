import 'package:flutter/material.dart';

/// Set [GlobalKey] for [Widget].
///
/// Only when invoking constructor can set [GlobalKey]. While this allows reset
/// [GlobalKey] and return intact.
class GlobalWidget extends StatelessWidget {
  final Widget child;

  const GlobalWidget({required GlobalKey super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}
