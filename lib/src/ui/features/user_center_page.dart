import 'package:flutter/material.dart';

class UserCenterPage extends StatelessWidget {
  const UserCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: const Text('我的'),
        ),
        Placeholder(),
      ],
    );
  }
}
