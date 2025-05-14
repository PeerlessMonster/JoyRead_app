import 'package:flutter/material.dart';

import '../../../../utils/theme.dart';
import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../widgets/skeleton.dart';

enum _DetailField {
  source('来源', Icon(Icons.domain_rounded)),
  writers('作者', Icon(Icons.people_rounded)),
  time('发布时间', Icon(Icons.calendar_month_rounded)),
  visitCount('浏览量', Icon(Icons.remove_red_eye_rounded));

  final String tooltip;
  final Icon icon;

  const _DetailField(this.tooltip, this.icon);
}

class NewsDetailGrid extends StatelessWidget {
  final String source;
  final List<String> writers;
  final String time;
  final String visitCount;

  const NewsDetailGrid(
      {super.key,
      required this.source,
      required this.writers,
      required this.time,
      required this.visitCount});

  @override
  Widget build(BuildContext context) => NewsDetailGridSkeleton(
        isLoading: false,
        source: source,
        writers: writers,
        time: time,
        visitCount: visitCount,
      );
}

class NewsDetailGridSkeleton extends StatelessWidget {
  /// Taking effect when any of [source], [writers], [time] or [visitCount] is
  /// null.
  final bool isLoading;
  final String? source;
  final List<String>? writers;
  final String? time;
  final String? visitCount;

  const NewsDetailGridSkeleton(
      {super.key,
      required this.isLoading,
      this.source,
      this.writers,
      this.time,
      this.visitCount});

  static const _spacing = spacing.Padding.increment * 2;

  Widget _buildLongLabel(List<String> texts) {
    final items = <Widget>[];

    final length = texts.length;
    for (var i = 0; i < length; i++) {
      items.add(Text(texts[i]));

      if (i < length - 1) {
        items.add(VerticalDivider());
      }
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }

  Widget _buildChip(Widget text, String tooltip, Icon icon) => Tooltip(
        message: tooltip,
        child: Chip(
          label: text,
          avatar: icon,
        ),
      );

  Widget _buildChipSkeleton(Icon icon, int width) => ChipSkeleton(
        avatar: icon,
        widthAsWordCount: width,
        playAnimation: isLoading,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: removeTapTargetMarginOnMobile(theme),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: _spacing,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: _spacing,
            children: [
              _checkIfLongChipFallback(writers, _DetailField.writers, 2),
              _checkIfChipFallback(source, _DetailField.source, 1),
            ],
          ),
          _checkIfChipFallback(time, _DetailField.time, 3),
          _checkIfChipFallback(visitCount, _DetailField.visitCount, 1),
        ],
      ),
    );
  }

  Widget _checkIfChipFallback(String? data, _DetailField field, int width) =>
      data == null
          ? _buildChipSkeleton(field.icon, width)
          : _buildChip(Text(data), field.tooltip, field.icon);

  Widget _checkIfLongChipFallback(
          List<String>? dataList, _DetailField meta, int width) =>
      dataList == null
          ? _buildChipSkeleton(meta.icon, width)
          : _buildChip(_buildLongLabel(dataList), meta.tooltip, meta.icon);
}
