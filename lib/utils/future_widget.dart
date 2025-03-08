import 'package:flutter/material.dart';

/// A wrapper of [FutureBuilder].
///
/// No need to write different branches and manually judge state for the
/// [builder] parameter of the [FutureBuilder] constructor, instead, just pass
/// builders or widgets.
class FutureWidget<T> extends StatelessWidget {
  final T? initialData;
  final Future<T>? dataFuture;
  final Widget uncompletedWidget;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final Widget Function(BuildContext context, Object error) errorBuilder;

  const FutureWidget(
      {super.key,
      this.initialData,
      required this.dataFuture,
      required this.uncompletedWidget,
      required this.dataBuilder,
      required this.errorBuilder});

  @override
  Widget build(BuildContext context) => FutureBuilder(
        initialData: initialData,
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataBuilder(context, snapshot.data!);
          } else if (snapshot.hasError) {
            return errorBuilder(context, snapshot.error!);
          } else {
            return uncompletedWidget;
          }
        },
      );
}
