import 'package:flutter/material.dart';

import 'constants/theme.dart';
import 'widgets/home_layout.dart';

class App extends StatelessWidget {
  const App({super.key});

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
