import 'package:flutter/material.dart';

import '../../../../utils/breakpoint.dart';
import '../../../core/breakpoint_state.dart';
import '../../../core/future_widget.dart';
import '../../../core/pressed_action.dart';
import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../widgets/action_scaffold.dart';
import '../../../widgets/sliver_app_bar.dart';
import '../view_models/extensions.dart';
import '../view_models/read_view_model.dart';
import 'news_detail_scroll_view.dart';

const _title = '阅读详情';

class _ReadScreen extends StatelessWidget {
  final List<Widget> sliversBody;
  final String? title;

  const _ReadScreen({super.key, required this.sliversBody, this.title});

  @override
  Widget build(BuildContext context) => ActionScaffold(
        bodyBuilder: (context, controller) => BreakpointProvider(
          child: CustomScrollView(
            controller: controller,
            slivers: [
              _AdaptiveFlexibleSliverAppBar(
                title: title ?? _title,
              ),
              ...sliversBody,
            ],
          ),
        ),
        floatingAction: PressedAction(
          name: 'Search',
          icon: Icon(Icons.auto_awesome_rounded),
          onPressed: () {},
        ),
        primaryActions: [
          PressedAction(
            name: 'Translate',
            icon: Icon(Icons.translate_rounded),
            onPressed: () {},
          ),
        ],
        secondaryActions: [
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
        ],
      );
}

class _AdaptiveFlexibleSliverAppBar extends StatelessWidget {
  final String title;

  const _AdaptiveFlexibleSliverAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    final breakpoint = BreakpointState.of(context);
    return breakpoint <= Breakpoint.compact
        ? FlexibleSliverAppBar(title: title)
        : FlexibleSliverAppBarWithoutLeading(title: title);
  }
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
