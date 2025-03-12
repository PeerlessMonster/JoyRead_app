import 'package:flutter/material.dart';

class PageBackAppBar {
  const PageBackAppBar._();

  static AppBar build(BuildContext context, {required String title}) =>
      AppBar(leading: _buildButton(context), title: Text(title));
}

class PageBackSliverAppBar extends StatelessWidget {
  final String title;

  const PageBackSliverAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) => SliverAppBar(
        leading: _buildButton(context),
        title: Text(title),
        floating: true,
      );
}

Widget _buildButton(BuildContext context) => IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(Icons.arrow_back_rounded),
    );
