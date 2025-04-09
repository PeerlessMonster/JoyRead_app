import 'package:flutter/material.dart';

import '../../../core/breakpoint_state.dart';
import '../../../core/future_widget.dart';
import '../../../core/pressed_action.dart';
import '../../../core/responsive_layout_builder.dart';
import '../../../widgets/narrow_screen_action_scaffold.dart';
import '../../../widgets/sliver_app_bar.dart';
import '../../../widgets/wide_screen_action_scaffold.dart';
import '../view_models/extensions.dart';
import '../view_models/read_view_model.dart';
import 'news_detail_scroll_view.dart';
import '../../../core/themes/constants/spacing.dart' as spacing;

const _title = '阅读详情';

class _ReadScreen extends StatelessWidget {
  final List<Widget> sliversBody;
  final String? title;

  const _ReadScreen({super.key, required this.sliversBody, this.title});

  PressedAction _buildFloatingAction() => PressedAction(
        name: 'Search',
        icon: Icon(Icons.auto_awesome_rounded),
        onPressed: () {},
      );

  List<PressedAction> _buildPrimaryActions() => [
        PressedAction(
          name: 'Translate',
          icon: Icon(Icons.translate_rounded),
          onPressed: () {},
        ),
      ];

  List<PressedAction> _buildSecondaryActions() => [
        PressedAction(
          name: 'Like',
          icon: Icon(Icons.thumb_up),
          onPressed: () {},
        ),
        PressedAction(
          name: 'Star',
          icon: Icon(Icons.star_rounded),
          onPressed: () {},
        ),
        PressedAction(
          name: 'Dislike',
          icon: Icon(Icons.thumb_down_rounded),
          onPressed: () {},
        ),
      ];

  @override
  Widget build(BuildContext context) => ResponsiveLayoutBuilder(
        narrowScreenWidget: ScrollingHiddenNarrowScreenActionScaffold(
          bodyBuilder: (context, controller) => BreakpointProvider(
            child: CustomScrollView(
              controller: controller,
              slivers: [
                FlexibleSliverAppBar(
                  title: title ?? _title,
                ),
                ...sliversBody,
              ],
            ),
          ),
          floatingAction: _buildFloatingAction(),
          primaryActions: _buildPrimaryActions(),
          secondaryActions: _buildSecondaryActions(),
        ),
        wideScreenWidget: WideScreenActionScaffold(
          body: BreakpointProvider(
            child: CustomScrollView(slivers: [
              FlexibleSliverAppBarWithoutLeading(
                title: title ?? _title,
              ),
              ...sliversBody,
            ]),
          ),
          floatingAction: _buildFloatingAction(),
          primaryActions: _buildPrimaryActions(),
          secondaryActions: _buildSecondaryActions(),
        ),
      );
}

class ReadScreen extends StatelessWidget {
  final String dataId;
  final String? title;
  final String? source;
  final List<String>? writers;
  final String? publishTime;
  final String? visitCount;

  ReadScreen(
      {super.key,
      required this.dataId,
      this.title,
      this.source,
      this.writers,
      this.publishTime,
      this.visitCount})
      : _viewModel = ReadViewModel(dataId);

  final ReadViewModel _viewModel;

  @override
  Widget build(BuildContext context) => FutureWidget(
        dataFuture: _viewModel.dataFuture,
        uncompletedWidget: _ReadScreen(
          key: key,
          title: title,
          sliversBody: buildDetailScrollViewSkeleton(
              true, source, writers, publishTime, visitCount),
        ),
        dataBuilder: (context, data) => _ReadScreen(
          key: key,
          title: data.title,
          sliversBody: buildDetailScrollView(
              data.source,
              data.writers,
              data.formattedPublishTime,
              '${data.view}',
              data.content,
              _viewModel.loadImageUrl,
              _viewModel.loadFallbackImage),
        ),
        errorBuilder: (context, _) => _ReadScreen(
          key: key,
          title: title,
          sliversBody: [
            ...buildDetailScrollViewSkeleton(
                false, source, writers, publishTime, visitCount),
            SliverPadding(
              padding: EdgeInsets.only(top: spacing.Padding.increment * 1),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: FilledButton.icon(
                    icon: Icon(Icons.refresh_rounded),
                    label: Text('Retry'),
                    onPressed: _viewModel.reload,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
