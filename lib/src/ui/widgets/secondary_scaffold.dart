import 'package:flutter/material.dart';

import 'sliver_app_bar.dart';

class SecondaryScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const SecondaryScaffold({super.key, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: body,
      );
}

class SliverSecondaryScaffold extends StatelessWidget {
  final String title;
  final List<Widget> bodySlivers;

  const SliverSecondaryScaffold(
      {super.key, required this.title, required this.bodySlivers});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(slivers: [
          RigidSliverAppBar(
            title: Text(title),
          ),
          ...bodySlivers,
        ]),
      );
}
