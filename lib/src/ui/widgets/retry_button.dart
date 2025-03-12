import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  final void Function() retry;

  const RetryButton({super.key, required this.retry});

  @override
  Widget build(BuildContext context) => FilledButton(
        onPressed: retry,
        child: Text('Retry'),
      );
}
