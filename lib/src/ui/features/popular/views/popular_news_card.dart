import 'package:flutter/material.dart';

import '../../../core/future_widget.dart';
import '../../../core/themes/constants/dimension.dart' as dimension;
import '../../../widgets/list_row.dart';
import '../../../widgets/list_section.dart';
import '../../reading/views/reading_screen.dart';
import '../view_models/popular_news_view_model.dart';

enum Sort {
  day('日榜'),
  week('周榜');

  final String title;

  const Sort(this.title);
}

class _PopularNewsCard extends StatelessWidget {
  final int childCount;
  final List<Widget> Function(BuildContext context, List<Widget> leadings)
      childrenBuilder;
  final Widget? header;
  final Widget? footer;

  const _PopularNewsCard(
      {super.key,
      required this.childCount,
      required this.childrenBuilder,
      this.header,
      this.footer})
      : assert(childCount > 0, 'Count of child should be positive integer');

  TextStyle? _buildTextStyle(BuildContext context, int index) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final textTheme = theme.textTheme;
    return textTheme.titleMedium
        ?.copyWith(
          color: index < 3
              ? colorScheme.tertiary
              : colorScheme.onSurface.withValues(alpha: 0.3),
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        )
        .apply(
          fontSizeFactor: 1.1,
        );
  }

  @override
  Widget build(BuildContext context) => ListSection(
        dividerIndentBehavior: ListSectionDividerIndentBehavior.leadingSkipped,
        dividerEndIndentBehavior:
            ListSectionDividerEndIndentBehavior.contentAligned,
        header: header,
        footer: footer,
        children: childrenBuilder(
            context,
            List.generate(
              childCount,
              (index) => Text(
                '${index + 1}',
                style: _buildTextStyle(context, index),
              ),
            )),
      );
}

class PopularNewsCard extends StatelessWidget {
  final Sort sort;
  final bool showHeader;
  static const _spacing = dimension.ListTile.contentVerticalPadding;

  PopularNewsCard({super.key, required this.sort, this.showHeader = true}) {
    _viewModel = switch (sort) {
      Sort.day => TodayPopularNewsViewModel(),
      Sort.week => ThisWeekPopularNewsViewModel(),
    };
  }

  late final PopularNewsViewModel _viewModel;

  Widget _buildHeader() => Padding(
        padding: EdgeInsets.only(top: _spacing),
        child: Chip(
          label: Text(sort.title),
        ),
      );

  @override
  Widget build(BuildContext context) => FutureWidget(
        dataFuture: _viewModel.dataFuture,
        uncompletedWidget: _PopularNewsCard(
          key: key,
          header: showHeader ? _buildHeader() : null,
          childCount: _viewModel.dataCount,
          childrenBuilder: (context, leadings) => leadings
              .map((leading) => ListRowSkeleton(
                    isLoading: true,
                    leading: leading,
                  ))
              .toList(),
        ),
        dataBuilder: (context, dataList) => _PopularNewsCard(
          key: key,
          header: showHeader ? _buildHeader() : null,
          childCount: dataList.length,
          childrenBuilder: (context, leadings) {
            final items = <Widget>[];

            for (var i = 0; i < dataList.length; i++) {
              final data = dataList[i];

              final item = ListRow(
                title: data.title,
                leading: leadings[i],
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadingScreen(
                        dataId: data.id,
                        title: data.title,
                      ),
                    )),
              );
              items.add(item);
            }
            return items;
          },
        ),
        errorBuilder: (context, _) => _PopularNewsCard(
          key: key,
          header: showHeader ? _buildHeader() : null,
          footer: Padding(
            padding: EdgeInsets.only(bottom: _spacing),
            child: FilledButton.icon(
              icon: Icon(Icons.refresh_rounded),
              label: Text('Retry'),
              onPressed: _viewModel.reload,
            ),
          ),
          childCount: _viewModel.dataCount,
          childrenBuilder: (context, leadings) => leadings
              .map((leading) => ListRowSkeleton(
                    isLoading: false,
                    leading: leading,
                  ))
              .toList(),
        ),
      );
}
