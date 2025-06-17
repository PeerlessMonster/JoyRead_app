import 'package:flutter/material.dart';

import '../../../core/themes/constants/dimension.dart' as dimension;
import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../widgets/skeleton.dart';
import '../../reading/views/reading_screen.dart';

const _padding = spacing.Padding.increment * 2;
const _spacing = spacing.Padding.increment * 5;

class _SearchResultCardLayout extends StatelessWidget {
  final Widget image;
  final Widget Function(BuildContext context, TextStyle? style) titleBuilder;
  final Widget Function(BuildContext context, TextStyle? style) subtitleBuilder;
  final Widget Function(BuildContext context, TextStyle? style) labelBuilder;
  final List<Widget> contents;
  final Widget? trailing;

  const _SearchResultCardLayout(
      {super.key,
      required this.image,
      required this.titleBuilder,
      required this.subtitleBuilder,
      required this.labelBuilder,
      required this.contents,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final items = <Widget>[
      titleBuilder(context, textTheme.headlineMedium),
      Divider(),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: _spacing,
        children: contents.indexed.map((record) {
          final (index, content) = record;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: spacing.Padding.increment * 2,
            children: [
              Text(
                '${index + 1}',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.tertiary,
                ),
              ),
              Expanded(child: content),
            ],
          );
        }).toList(),
      ),
    ];
    if (trailing != null) {
      items.add(trailing!);
    }
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(_padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                subtitleBuilder(
                    context,
                    textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                labelBuilder(context, textTheme.labelLarge),
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: image,
          ),
          Padding(
            padding: const EdgeInsets.all(_padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items,
            ),
          )
        ],
      ),
    );
  }
}

class SearchResultCard extends StatelessWidget {
  final String dataId;
  final Widget image;
  final String title;
  final List<String> segments;
  final String source;
  final String time;
  static const _horizontalPadding = dimension.Card.horizontalPadding - _padding;

  const SearchResultCard(
      {super.key,
      required this.dataId,
      required this.image,
      required this.title,
      required this.segments,
      required this.source,
      required this.time});

  @override
  Widget build(BuildContext context) => _SearchResultCardLayout(
        key: key,
        image: image,
        titleBuilder: (context, style) => Text(
          title,
          style: style,
        ),
        subtitleBuilder: (context, style) => Text(
          source,
          style: style,
        ),
        labelBuilder: (context, style) => Text(
          time,
          style: style,
        ),
        contents: segments.map((segment) => Text('……$segment……')).toList(),
        trailing: Padding(
          padding: EdgeInsets.only(
            left: _horizontalPadding,
            right: _horizontalPadding,
            top: _spacing,
          ),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadingScreen(dataId: dataId),
                  )),
              child: Text('阅读详情'),
            ),
          ),
        ),
      );
}

class SearchResultCardSkeleton extends StatelessWidget {
  final bool isLoading;

  const SearchResultCardSkeleton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) => _SearchResultCardLayout(
        image: BoxSkeleton(
          playAnimation: isLoading,
        ),
        titleBuilder: (context, style) => TextSkeleton(
          playAnimation: isLoading,
          widthAsWordCount: 3,
          style: style,
        ),
        subtitleBuilder: (context, style) => TextSkeleton(
          playAnimation: isLoading,
          widthAsWordCount: 2,
          style: style,
        ),
        labelBuilder: (context, style) => TextSkeleton(
          playAnimation: isLoading,
          widthAsWordCount: 1,
          style: style,
        ),
        contents: List.generate(
          3,
          (_) => MultiTextSkeleton(playAnimation: isLoading),
        ),
      );
}
