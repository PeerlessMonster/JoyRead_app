import 'package:flutter/material.dart';

/// A custom [Notification] describing network state.
///
/// If not able to access network, use [NetworkNotification.error()] to create
/// an [Error], then dispatch it.
/// once error network restores, use [NetworkNotification.restored()] to create
/// an [Restored], then dispatch as well.
///
/// See also:
///
/// * [NetworkNotificationListener]
sealed class NetworkNotification extends Notification {
  const NetworkNotification();

  const factory NetworkNotification.error() = Error._;

  const factory NetworkNotification.restored() = Restored._;
}

/// A custom [Notification] describing the state of error network.
class Error extends NetworkNotification {
  const Error._();
}

/// A custom [Notification] describing the state of restored network.
class Restored extends NetworkNotification {
  const Restored._();
}

/// A [NotificationListener] for [NetworkNotification].
///
/// No need to manually switch different states and write functions, instead,
/// just pass callbacks.
class NetworkNotificationListener extends StatelessWidget {
  final Widget child;
  final void Function()? onNetworkError;
  final void Function()? onNetworkRestored;

  const NetworkNotificationListener(
      {super.key,
      required this.onNetworkError,
      required this.onNetworkRestored,
      required this.child});

  @override
  Widget build(BuildContext context) =>
      NotificationListener<NetworkNotification>(
        onNotification: (notification) {
          switch (notification) {
            case Error():
              if (onNetworkError != null) {
                onNetworkError!();
              }

            case Restored():
              if (onNetworkRestored != null) {
                onNetworkRestored!();
              }
          }
          return true;
        },
        child: child,
      );
}
