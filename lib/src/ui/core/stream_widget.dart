import 'package:flutter/material.dart';

/// A wrapper of [StreamBuilder].
///
/// No need to write different branches and manually judge state for the
/// [builder] parameter of the [StreamBuilder] constructor, instead, just pass
/// builders or widgets.
class StreamWidget<T> extends StatelessWidget {
  final T? initialData;
  final Stream<T>? stream;
  final Widget Function(BuildContext context, T? initialData)
      unconnectedBuilder;
  final Widget waitingWidget;
  final Widget Function(BuildContext context, T data) activeBuilder;
  final Widget Function(BuildContext context, T data) doneBuilder;
  final Widget Function(BuildContext context, Object error) errorBuilder;

  const StreamWidget(
      {super.key,
      this.initialData,
      required this.stream,
      required this.unconnectedBuilder,
      required this.waitingWidget,
      required this.activeBuilder,
      required this.doneBuilder,
      required this.errorBuilder});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        initialData: initialData,
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return errorBuilder(context, snapshot.error!);
          }
          return switch (snapshot.connectionState) {
            ConnectionState.none => unconnectedBuilder(context, snapshot.data),
            ConnectionState.waiting => waitingWidget,
            ConnectionState.active => activeBuilder(context, snapshot.data!),
            ConnectionState.done => doneBuilder(context, snapshot.data!),
          };
        },
      );
}
