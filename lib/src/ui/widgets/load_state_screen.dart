import 'package:flutter/material.dart';

class LoadStateScreen extends StatelessWidget {
  final String title;
  final Widget sign;

  const LoadStateScreen({super.key, required this.title, required this.sign});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: sign,
        ),
      );
}
