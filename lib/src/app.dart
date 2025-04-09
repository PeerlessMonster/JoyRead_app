import 'package:flutter/material.dart';

import 'ui/core/themes/theme.dart';
import 'ui/features/home_screen.dart';
import 'utils/theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    final textTheme = Theme.of(context).textTheme;
    final theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: addTapTargetMarginOnDesktop(
          brightness == Brightness.light ? theme.light() : theme.dark()),
      home: const HomeScreen(),
    );
  }
}
