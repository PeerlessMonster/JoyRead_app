import 'package:flutter/material.dart';

import '../core/future_widget.dart';
import 'secondary_scaffold.dart';

class LoadStateChangedSecondaryScaffold<T> extends StatelessWidget {
  final T? initialData;
  final Future<T> dataFuture;
  final String title;
  final Widget uncompletedSign;
  final Widget Function(BuildContext context, T data) bodyBuilder;
  final Widget Function(BuildContext context, Object error) errorSignBuilder;

  const LoadStateChangedSecondaryScaffold(
      {super.key,
      this.initialData,
      required this.dataFuture,
      required this.title,
      required this.uncompletedSign,
      required this.bodyBuilder,
      required this.errorSignBuilder});

  @override
  Widget build(BuildContext context) => SecondaryScaffold(
        title: title,
        body: FutureWidget(
          initialData: initialData,
          dataFuture: dataFuture,
          uncompletedWidget: Center(
            child: uncompletedSign,
          ),
          dataBuilder: (context, data) => bodyBuilder(context, data),
          errorBuilder: (context, error) => Center(
            child: errorSignBuilder(context, error),
          ),
        ),
      );
}

class SliverLoadStateChangedSecondaryScaffold<T>
    extends StatelessWidget {
  final T? initialData;
  final Future<T> dataFuture;
  final String title;
  final Widget uncompletedSign;
  final List<Widget> Function(BuildContext context, T data) sliversBodyBuilder;
  final Widget Function(BuildContext context, Object error) errorSignBuilder;

  const SliverLoadStateChangedSecondaryScaffold(
      {super.key,
      this.initialData,
      required this.dataFuture,
      required this.title,
      required this.uncompletedSign,
      required this.sliversBodyBuilder,
      required this.errorSignBuilder});

  @override
  Widget build(BuildContext context) => FutureWidget(
        initialData: initialData,
        dataFuture: dataFuture,
        uncompletedWidget: SecondaryScaffold(
          title: title,
          body: Center(
            child: uncompletedSign,
          ),
        ),
        dataBuilder: (context, data) => SliverSecondaryScaffold(
          title: title,
          sliversBody: sliversBodyBuilder(context, data),
        ),
        errorBuilder: (context, error) => SecondaryScaffold(
          title: title,
          body: Center(
            child: errorSignBuilder(context, error),
          ),
        ),
      );
}
