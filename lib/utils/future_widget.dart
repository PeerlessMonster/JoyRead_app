import 'package:flutter/material.dart';

/// A wrapper of [FutureBuilder].
///
/// No need to write different branches and manually judge state for the [builder]
/// parameter of the [FutureBuilder] constructor, instead, just pass builders or widgets.
class FutureWidget<T> extends StatelessWidget {
  final T? initialData;
  final Future<T>? data;
  final Widget uncompletedWidget;
  final Widget Function(BuildContext context, T data) successBuilder;
  final Widget Function(BuildContext context, Object error) errorBuilder;

  const FutureWidget(
      {super.key,
      this.initialData,
      required this.data,
      required this.uncompletedWidget,
      required this.successBuilder,
      required this.errorBuilder});

  @override
  Widget build(BuildContext context) => FutureBuilder(
        initialData: initialData,
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return successBuilder(context, snapshot.data!);
          } else if (snapshot.hasError) {
            return errorBuilder(context, snapshot.error!);
          } else {
            return uncompletedWidget;
          }
        },
      );
}
