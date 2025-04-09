import 'package:flutter/material.dart';

import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../widgets/skeleton.dart';

const _sourceIcon = Icon(Icons.domain_rounded);
const _timeIcon = Icon(Icons.calendar_month_rounded);
const _writersIcon = Icon(Icons.people_rounded);

class _NewsMetaGrid extends StatelessWidget {
  final Widget longChip;
  final Widget shortChip1;
  final Widget shortChip2;
  static const _spacing = spacing.Padding.increment * 2;

  const _NewsMetaGrid(
      {super.key,
      required this.longChip,
      required this.shortChip1,
      required this.shortChip2});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: _spacing,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: _spacing,
          children: [
            longChip,
            shortChip1,
          ],
        ),
        shortChip2,
      ],
    );
  }
}

Widget _buildLongLabel(List<String> data) {
  final items = <Widget>[];

  final length = data.length;
  for (var i = 0; i < length; i++) {
    items.add(Text(data[i]));

    if (i < length - 1) {
      items.add(VerticalDivider());
    }
  }
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: items,
  );
}

class NewsMetaGrid extends StatelessWidget {
  final String source;
  final List<String> writers;
  final String time;

  const NewsMetaGrid(
      {super.key,
      required this.source,
      required this.writers,
      required this.time});

  @override
  Widget build(BuildContext context) => _NewsMetaGrid(
        key: key,
        longChip: Chip(
          label: _buildLongLabel(writers),
          avatar: _writersIcon,
        ),
        shortChip1: Chip(
          label: Text(source),
          avatar: _sourceIcon,
        ),
        shortChip2: Chip(
          label: Text(time),
          avatar: _timeIcon,
        ),
      );
}

class NewsMetaContainerSkeleton extends StatelessWidget {
  final bool isLoading;
  final String? source;
  final List<String>? writers;
  final String? time;

  const NewsMetaContainerSkeleton(
      {super.key,
      required this.isLoading,
      this.source,
      this.writers,
      this.time});

  @override
  Widget build(BuildContext context) => _NewsMetaGrid(
        key: key,
        longChip: writers == null
            ? ChipSkeleton(
                avatar: _writersIcon,
                widthAsWordCount: 2,
                playAnimation: isLoading,
              )
            : Chip(
                label: _buildLongLabel(writers!),
                avatar: _writersIcon,
              ),
        shortChip1: source == null
            ? ChipSkeleton(
                avatar: _sourceIcon,
                widthAsWordCount: 1,
                playAnimation: isLoading,
              )
            : Chip(
                label: Text(source!),
                avatar: _sourceIcon,
              ),
        shortChip2: time == null
            ? ChipSkeleton(
                avatar: _timeIcon,
                playAnimation: isLoading,
              )
            : Chip(
                label: Text(time!),
                avatar: _timeIcon,
              ),
      );
}
