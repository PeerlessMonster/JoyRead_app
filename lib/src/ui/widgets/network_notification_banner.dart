import 'package:flutter/material.dart';

import 'notification_banner.dart';

class NetworkErrorNotificationBanner extends StatelessWidget {
  final void Function() onClose;
  final bool capsuleShaped;
  final double? elevation;

  const NetworkErrorNotificationBanner(
      {super.key,
      required this.onClose,
      this.capsuleShaped = false,
      this.elevation});

  @override
  Widget build(BuildContext context) => NotificationBanner(
        key: key,
        text: '当前无法连接网络，网络设置正常后再回来吧~',
        icon: Icon(
          Icons.highlight_off_rounded,
          color: Colors.red,
        ),
        onClose: onClose,
        capsuleShaped: capsuleShaped,
        elevation: elevation,
      );
}

class NetworkRestoredNotificationBanner extends StatelessWidget {
  final void Function() onClose;
  final bool capsuleShaped;
  final double? elevation;

  const NetworkRestoredNotificationBanner(
      {super.key,
      required this.onClose,
      this.capsuleShaped = false,
      this.elevation});

  @override
  Widget build(BuildContext context) => NotificationBanner(
        key: key,
        text: '网络连接已恢复~',
        icon: Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green,
        ),
        onClose: onClose,
        capsuleShaped: capsuleShaped,
        elevation: elevation,
      );
}
