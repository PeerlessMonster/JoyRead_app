import 'package:flutter/material.dart';

import '../core/future_widget.dart';
import 'secondary_scaffold.dart';

class LoadStateChangedSecondaryScaffoldWithSign<T> extends StatelessWidget {
  final T? initialData;
  final Future<T> dataFuture;
  final String title;
  final Widget uncompletedSign;
  final Widget Function(BuildContext context, T data) bodyBuilder;
  final Widget Function(BuildContext context, Object error) errorSignBuilder;

  const LoadStateChangedSecondaryScaffoldWithSign(
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

class SliverLoadStateChangedSecondaryScaffoldWithSign<T>
    extends StatelessWidget {
  final T? initialData;
  final Future<T> dataFuture;
  final String title;
  final Widget uncompletedSign;
  final List<Widget> Function(BuildContext context, T data) bodySliversBuilder;
  final Widget Function(BuildContext context, Object error) errorSignBuilder;

  const SliverLoadStateChangedSecondaryScaffoldWithSign(
      {super.key,
      this.initialData,
      required this.dataFuture,
      required this.title,
      required this.uncompletedSign,
      required this.bodySliversBuilder,
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
          bodySlivers: bodySliversBuilder(context, data),
        ),
        errorBuilder: (context, error) => SecondaryScaffold(
          title: title,
          body: errorSignBuilder(context, error),
        ),
      );
}
