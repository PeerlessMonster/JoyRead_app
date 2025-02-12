import 'package:flutter/material.dart';

import 'constants/theme.dart';
import 'router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    final textTheme = Theme.of(context).textTheme;
    final theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const HomeLayout(),
    );
  }
}
