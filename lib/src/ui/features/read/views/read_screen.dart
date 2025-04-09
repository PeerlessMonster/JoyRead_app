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

final _floatingAction = PressedAction(
  name: 'Search',
  icon: Icon(Icons.search_rounded),
  onPressed: () {},
);
final _primaryActions = [
  PressedAction(
    name: 'Summary',
    icon: Icon(Icons.summarize_outlined),
    onPressed: () {},
  ),
  PressedAction(
    name: 'Translate',
    icon: Icon(Icons.translate_rounded),
    onPressed: () {},
  ),
];
final _secondaryActions = [
  PressedAction(
    name: 'Star',
    icon: Icon(Icons.star_rounded),
    onPressed: () {},
  ),
  PressedAction(
    name: 'Like',
    icon: Icon(Icons.thumb_up),
    onPressed: () {},
  ),
  PressedAction(
    name: 'Dislike',
    icon: Icon(Icons.thumb_down_rounded),
    onPressed: () {},
  )
];

class _ReadScreen extends StatelessWidget {
  final String title;
  final List<Widget> sliversBody;

  const _ReadScreen(
      {super.key, required this.title, required this.sliversBody});

  @override
  Widget build(BuildContext context) => ResponsiveLayoutBuilder(
        narrowScreenWidget: ScrollingHiddenNarrowScreenActionScaffold(
          bodyBuilder: (context, controller) => BreakpointProvider(
            child: CustomScrollView(
              controller: controller,
              slivers: [
                FlexibleSliverAppBar(
                  title: title,
                ),
                ...sliversBody,
              ],
            ),
          ),
          floatingAction: _floatingAction,
          primaryActions: _primaryActions,
          secondaryActions: _secondaryActions,
        ),
        wideScreenWidget: WideScreenActionScaffold(
          body: BreakpointProvider(
            child: CustomScrollView(slivers: [
              FlexibleSliverAppBarWithoutLeading(
                title: title,
              ),
              ...sliversBody,
            ]),
          ),
          floatingAction: _floatingAction,
          primaryActions: _primaryActions,
          secondaryActions: _secondaryActions,
        ),
      );
}

class ReadScreen extends StatelessWidget {
  final String dataId;
  final String title;
  final String? source;
  final List<String>? writers;
  final String? publishTime;

  ReadScreen(
      {super.key,
      required this.dataId,
      this.title = '阅读详情',
      this.source,
      this.writers,
      this.publishTime})
      : _viewModel = ReadViewModel(dataId);

  final ReadViewModel _viewModel;

  @override
  Widget build(BuildContext context) => FutureWidget(
        dataFuture: _viewModel.dataFuture,
        uncompletedWidget: _ReadScreen(
          key: key,
          title: title,
          sliversBody: buildDetailScrollViewSkeleton(
              true, source, writers, publishTime),
        ),
        dataBuilder: (context, data) => _ReadScreen(
          key: key,
          title: data.title,
          sliversBody: buildDetailScrollView(
              data.source,
              data.writers,
              data.formattedPublishTime,
              data.content,
              _viewModel.loadImageUrl,
              _viewModel.loadFallbackImage),
        ),
        errorBuilder: (context, _) => _ReadScreen(
          key: key,
          title: title,
          sliversBody: buildDetailScrollViewSkeleton(
              false, source, writers, publishTime),
        ),
      );
}
