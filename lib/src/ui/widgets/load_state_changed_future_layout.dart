import 'package:flutter/material.dart';

import '../core/future_widget.dart';
import 'title_layout.dart';

class LoadStateChangedFutureLayoutWithSign<T> extends StatelessWidget {
  final T? initialData;
  final Future<T> dataFuture;
  final String title;
  final Widget uncompletedSign;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final Widget Function(BuildContext context, Object error) errorSignBuilder;

  const LoadStateChangedFutureLayoutWithSign(
      {super.key,
      this.initialData,
      required this.dataFuture,
      required this.title,
      required this.uncompletedSign,
      required this.dataBuilder,
      required this.errorSignBuilder});

  @override
  Widget build(BuildContext context) => FutureWidget(
        initialData: initialData,
        dataFuture: dataFuture,
        uncompletedWidget: TitleLayoutWithPageBack(
          title: title,
          body: Center(
            child: uncompletedSign,
          ),
        ),
        dataBuilder: (context, data) => TitleLayoutWithPageBack(
          title: title,
          body: dataBuilder(context, data),
        ),
        errorBuilder: (context, error) => TitleLayoutWithPageBack(
          title: title,
          body: Center(
            child: errorSignBuilder(context, error),
          ),
        ),
      );
}

class LoadStateChangedFutureSliverLayoutWithSign<T> extends StatelessWidget {
  final T? initialData;
  final Future<T> dataFuture;
  final String title;
  final Widget uncompletedSign;
  final List<Widget> Function(BuildContext context, T data) dataBuilder;
  final Widget Function(BuildContext context, Object error) errorSignBuilder;

  const LoadStateChangedFutureSliverLayoutWithSign(
      {super.key,
      this.initialData,
      required this.dataFuture,
      required this.title,
      required this.uncompletedSign,
      required this.dataBuilder,
      required this.errorSignBuilder});

  @override
  Widget build(BuildContext context) => FutureWidget(
        initialData: initialData,
        dataFuture: dataFuture,
        uncompletedWidget: TitleLayoutWithPageBack(
          title: title,
          body: Center(
            child: uncompletedSign,
          ),
        ),
        dataBuilder: (context, data) => TitleSliverLayoutWithPageBack(
          title: title,
          body: dataBuilder(context, data),
        ),
        errorBuilder: (context, error) => TitleLayoutWithPageBack(
          title: title,
          body: Center(
            child: errorSignBuilder(context, error),
          ),
        ),
      );
}
