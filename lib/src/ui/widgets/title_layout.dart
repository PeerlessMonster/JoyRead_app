import 'package:flutter/material.dart';

import 'page_back_app_bar.dart';

class TitleLayoutWithPageBack extends StatelessWidget {
  final Widget body;
  final String title;

  const TitleLayoutWithPageBack(
      {super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PageBackAppBar.build(context, title: title),
        body: body,
      );
}

class TitleSliverLayoutWithPageBack extends StatelessWidget {
  final List<Widget> body;
  final String title;

  const TitleSliverLayoutWithPageBack(
      {super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            PageBackSliverAppBar(
              title: title,
            ),
            ...body,
          ],
        ),
      );
}
