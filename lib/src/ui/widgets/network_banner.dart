import 'package:flutter/material.dart';

import 'message_banner.dart';

class ErrorNetworkBanner extends StatelessWidget {
  final void Function() onDismissed;
  final MessageBannerBehavior behavior;

  const ErrorNetworkBanner(
      {super.key,
      required this.onDismissed,
      this.behavior = MessageBannerBehavior.fixed});

  @override
  Widget build(BuildContext context) => MessageBanner(
        key: key,
        text: '当前无法连接网络，网络设置正常后再回来吧~',
        icon: Icon(
          Icons.highlight_off_rounded,
          color: Colors.red,
        ),
        actions: [_buildCloseButton(context, onDismissed)],
        behavior: behavior,
      );
}

class RestoredNetworkBanner extends StatelessWidget {
  final void Function() onDismissed;
  final MessageBannerBehavior behavior;

  const RestoredNetworkBanner(
      {super.key,
      required this.onDismissed,
      this.behavior = MessageBannerBehavior.fixed});

  @override
  Widget build(BuildContext context) => MessageBanner(
        key: key,
        text: '网络连接已恢复~',
        icon: Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green,
        ),
        actions: [_buildCloseButton(context, onDismissed)],
        behavior: behavior,
      );
}

Widget _buildCloseButton(BuildContext context, void Function() onPressed) {
  final colorScheme = Theme.of(context).colorScheme;

  return IconButton(
    tooltip: 'Dismiss',
    icon: Icon(
      Icons.close_rounded,
      color: colorScheme.onInverseSurface,
    ),
    onPressed: onPressed,
  );
}
