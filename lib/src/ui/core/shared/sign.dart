import 'package:flutter/material.dart';

import '../../widgets/alert.dart';
import '../../widgets/retry_button.dart';
import 'illustration.dart';

class LoadingSign extends StatelessWidget {
  const LoadingSign({super.key});

  @override
  Widget build(BuildContext context) => ImageAlert(
        image: Image.asset(Illustration.loading.assetName),
        content: '加载中……',
      );
}

class NoNetworkSign extends StatelessWidget {
  final void Function() retry;

  const NoNetworkSign({super.key, required this.retry});

  @override
  Widget build(BuildContext context) => ImageAlert(
        image: Image.asset(Illustration.noNetwork.assetName),
        content: 'Unable to access network.',
        actions: [
          RetryButton(
            retry: retry,
          ),
        ],
      );
}
