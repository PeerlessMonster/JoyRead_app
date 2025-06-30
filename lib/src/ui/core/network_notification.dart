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
///  * [NetworkNotificationListener]
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
///
/// If [Error] is received, [onError] will be invoked only at the first time,
/// not repeatedly. The same as [Restored] to [onRestored].
class NetworkNotificationListener extends StatefulWidget {
  final Widget Function(BuildContext context, bool hasError) childBuilder;
  final void Function()? onError;
  final void Function()? onRestored;

  const NetworkNotificationListener(
      {super.key,
      required this.onError,
      required this.onRestored,
      required this.childBuilder});

  @override
  State<NetworkNotificationListener> createState() =>
      _NetworkNotificationListenerState();
}

class _NetworkNotificationListenerState
    extends State<NetworkNotificationListener> {
  var hasError = false;

  @override
  Widget build(BuildContext context) =>
      NotificationListener<NetworkNotification>(
        onNotification: (notification) {
          switch (notification) {
            case Error():
              if (widget.onError == null) {
                break;
              }

              if (!hasError) {
                setState(() {
                  hasError = true;
                });

                widget.onError!();
              }

            case Restored():
              if (widget.onRestored == null) {
                break;
              }

              if (hasError) {
                setState(() {
                  hasError = false;
                });

                widget.onRestored!();
              }
          }
          return true;
        },
        child: widget.childBuilder(context, hasError),
      );
}
