import 'package:flutter/material.dart';

import 'ui/core/themes/theme.dart';
import 'ui/features/home_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static ThemeData _setPossibleMarginToBlankOnTouchDevice(
          ThemeData themeData) =>
      themeData.copyWith(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    final textTheme = Theme.of(context).textTheme;
    final theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: brightness == Brightness.light
          ? _setPossibleMarginToBlankOnTouchDevice(theme.light())
          : _setPossibleMarginToBlankOnTouchDevice(theme.dark()),
      home: const HomeScreen(),
    );
  }
}
