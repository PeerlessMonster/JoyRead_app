import 'package:flutter/material.dart';

import '../../../../data/models/news.dart';
import '../../../../utils/breakpoint.dart';
import '../../../core/max_width_box.dart';
import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../widgets/load_state_changed_network_image.dart';

const _maxBreakpoint = Breakpoint.expanded;

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
      1 => textTheme.titleLarge?.copyWith(color: colorScheme.tertiary),
      2 => textTheme.titleMedium?.copyWith(color: colorScheme.tertiary),
      >= 3 => textTheme.titleSmall?.copyWith(color: colorScheme.tertiary),
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
  Widget build(BuildContext context) => MaxWidthBox.breakpoint(
        endpoint: _maxBreakpoint,
        child: LoadStateChangedNetworkImage(
          url,
          fallbackImageAssetName: fallbackImageAssetName,
          foregroundColor: foregroundColor,
          placeholderAspectRatio: 16 / 9,
        ),
      );
}

class AnnotationBlockWidget extends StatelessWidget {
  final List<SpanBlock> spans;

  const AnnotationBlockWidget({super.key, required this.spans});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final textTheme = theme.textTheme;
    final textStyle = textTheme.labelLarge?.copyWith(
      color: colorScheme.onSurface.withValues(alpha: 0.5),
    );

    return MaxWidthBox.breakpoint(
      endpoint: _maxBreakpoint,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colorScheme.tertiary),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: spacing.Padding.increment * 1),
          child: _SpanBlocksWidget(
            key: key,
            spans: spans,
            rootTextSpanStyle: textStyle,
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
        padding: const EdgeInsets.all(spacing.Padding.increment * 4),
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
          start: BorderSide(color: colorScheme.tertiary),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
            start: spacing.Padding.increment * 2),
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
  final LeadingBlock? leading;
  final List<SpanBlock> spans;

  const BodyBlockWidget({super.key, this.leading, required this.spans});

  Widget _buildSpanBlocks() => _SpanBlocksWidget(
        key: key,
        spans: spans,
      );

  @override
  Widget build(BuildContext context) => leading == null
      ? _buildSpanBlocks()
      : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: spacing.Padding.increment * 2,
          children: [
            LeadingBlockWidget(leading: leading!),
            Expanded(
              child: _buildSpanBlocks(),
            ),
          ],
        );
}

class _SpanBlocksWidget extends StatelessWidget {
  final List<SpanBlock> spans;
  final TextStyle? rootTextSpanStyle;

  const _SpanBlocksWidget(
      {super.key, required this.spans, this.rootTextSpanStyle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final defaultTextStyle = DefaultTextStyle.of(context).style;

    return Text.rich(
      TextSpan(
        children: spans.map((span) {
          final textStyle = switch (span.style) {
            SpanStyle.normal => null,
            SpanStyle.bold => TextStyle(fontWeight: FontWeight.bold),
            SpanStyle.italic => TextStyle(fontStyle: FontStyle.italic),
            SpanStyle.colored => TextStyle(color: colorScheme.tertiary),
            SpanStyle.boldColored => TextStyle(
                color: colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            SpanStyle.italicBold => TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
          };

          return TextSpan(
            text: span.text,
            style: textStyle,
          );
        }).toList(),
        style: rootTextSpanStyle ?? defaultTextStyle,
      ),
    );
  }
}

class LeadingBlockWidget extends StatelessWidget {
  final LeadingBlock leading;

  const LeadingBlockWidget({super.key, required this.leading});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final defaultTextStyle = DefaultTextStyle.of(context).style;
    final textStyle = switch (leading.style) {
      LeadingStyle.sign => defaultTextStyle
          .copyWith(
            height: 0.37,
            color: colorScheme.tertiary,
            fontWeight: FontWeight.bold,
          )
          .apply(fontSizeFactor: 3),
      LeadingStyle.order => defaultTextStyle
          .copyWith(
            height: 0.7,
            color: colorScheme.tertiary,
          )
          .apply(fontSizeFactor: 2),
    };

    return Text(
      leading.text,
      style: textStyle,
    );
  }
}
