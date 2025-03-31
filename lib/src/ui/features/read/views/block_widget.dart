import 'package:flutter/material.dart';

import '../../../../data/models/news.dart';
import '../../../../utils/breakpoint.dart';
import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../widgets/load_state_changed_network_image.dart';

class HeadingBlockWidget extends StatelessWidget {
  final String text;
  final int level;

  const HeadingBlockWidget({super.key, required this.text, required this.level})
      : assert(level > 0, 'Level of heading should be positive integer');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final textTheme = theme.textTheme;
    final textStyle = switch (level) {
      1 => textTheme.titleLarge?.copyWith(
          color: colorScheme.tertiary,
        ),
      2 => textTheme.titleMedium?.copyWith(
          color: colorScheme.tertiary,
        ),
      >= 3 => textTheme.titleSmall?.copyWith(
          color: colorScheme.tertiary,
        ),
      _ => throw RangeError.range(level, 1, null, 'level',
          'Level of heading should be positive integer'),
    };

    return Text(
      text,
      style: textStyle,
    );
  }
}

class ImageBlockWidget extends StatelessWidget {
  final String url;
  final String fallbackImageAssetName;
  final Color foregroundColor;

  const ImageBlockWidget(
      {super.key,
      required this.url,
      required this.fallbackImageAssetName,
      required this.foregroundColor});

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          width: Breakpoint.medium.screenWidthRange.end,
          child: LoadStateChangedNetworkImage(
            url,
            fallbackImageAssetName: fallbackImageAssetName,
            foregroundColor: foregroundColor,
            placeholderAspectRatio: 16 / 9,
          ),
        ),
      );
}

class ImageDescriptionBlockWidget extends StatelessWidget {
  final List<SpanBlock> spans;

  const ImageDescriptionBlockWidget({super.key, required this.spans});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final textTheme = theme.textTheme;
    final textStyle = textTheme.labelLarge?.copyWith(
      color: colorScheme.onSurface.withValues(alpha: 0.5),
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
            width: Breakpoint.medium.screenWidthRange.end),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colorScheme.tertiary,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: spacing.Padding.increment * 1),
            child: _SpansBlockLayout(
              key: key,
              spans: spans,
              rootTextSpanStyle: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}

class ContextBlockWidget extends StatelessWidget {
  final List<Widget> children;

  const ContextBlockWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.tertiaryContainer.withValues(alpha: 0.2),
      child: Padding(
        padding: EdgeInsets.all(spacing.Padding.increment * 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class QuoteBlockWidget extends StatelessWidget {
  final List<Widget> children;

  const QuoteBlockWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: BorderDirectional(
          start: BorderSide(
            color: colorScheme.tertiary,
          ),
        ),
      ),
      child: Padding(
        padding:
            EdgeInsetsDirectional.only(start: spacing.Padding.increment * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class BodyBlockWidget extends StatelessWidget {
  final List<SpanBlock> spans;

  const BodyBlockWidget({super.key, required this.spans});

  @override
  Widget build(BuildContext context) => _SpansBlockLayout(
        key: key,
        spans: spans,
      );
}

class _SpansBlockLayout extends StatelessWidget {
  final List<SpanBlock> spans;
  final TextStyle? rootTextSpanStyle;

  const _SpansBlockLayout(
      {super.key, required this.spans, this.rootTextSpanStyle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defaultTextStyle = DefaultTextStyle.of(context).style;

    final firstSpanStyle = spans[0].style;
    final hasLeading =
        firstSpanStyle == SpanStyle.order || firstSpanStyle == SpanStyle.sign;

    final mainSpans = hasLeading ? spans.skip(1) : spans;
    final mainWidget = Text.rich(
      TextSpan(
        children: mainSpans.map((span) {
          final textStyle = switch (span.style) {
            SpanStyle.normal => null,
            SpanStyle.bold => TextStyle(
                fontWeight: FontWeight.bold,
              ),
            SpanStyle.italic => TextStyle(
                fontStyle: FontStyle.italic,
              ),
            SpanStyle.colored => TextStyle(
                color: colorScheme.tertiary, fontWeight: FontWeight.bold),
            _ => throw FormatException(
                "No textStyle for ${span.style} after the first span of a paragraph"),
          };

          return TextSpan(
            text: span.text,
            style: textStyle,
          );
        }).toList(),
        style: rootTextSpanStyle ?? defaultTextStyle,
      ),
    );
    if (!hasLeading) {
      return mainWidget;
    }

    final textStyle = switch (firstSpanStyle) {
      SpanStyle.sign => defaultTextStyle
          .copyWith(
            height: 0.37,
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          )
          .apply(
            fontSizeFactor: 3,
          ),
      SpanStyle.order => defaultTextStyle
          .copyWith(
            height: 0.7,
            color: colorScheme.primary,
          )
          .apply(
            fontSizeFactor: 2,
          ),
      _ => throw UnimplementedError(
          "No textStyle for $firstSpanStyle when this paragraph has leading"),
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsetsDirectional.only(end: spacing.Padding.increment * 2),
          child: Text(
            spans[0].text,
            style: textStyle,
          ),
        ),
        Expanded(
          child: mainWidget,
        ),
      ],
    );
  }
}
