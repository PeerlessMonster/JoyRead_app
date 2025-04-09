import 'package:flutter/material.dart';

import '../core/future_widget.dart';
import 'load_state_screen.dart';

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
  Widget build(BuildContext context) => FutureWidget(
        initialData: initialData,
        dataFuture: dataFuture,
        uncompletedWidget: LoadStateScreen(
          title: title,
          sign: uncompletedSign,
        ),
        dataBuilder: (context, data) => Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: bodyBuilder(context, data),
        ),
        errorBuilder: (context, error) => LoadStateScreen(
          title: title,
          sign: errorSignBuilder(context, error),
        ),
      );
}
