import 'package:flutter/material.dart';

import '../../../core/breakpoint_state.dart';
import '../../../core/future_widget.dart';
import '../../../core/pressed_action.dart';
import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../widgets/action_scaffold.dart';
import '../../assistant/views/assistant_screen.dart';
import '../view_models/extensions.dart';
import '../view_models/reading_view_model.dart';
import 'news_scroll_view.dart';

const _title = '阅读详情';

class _ReadingScreen extends StatelessWidget {
  final Widget Function(BuildContext context, ScrollController controller)
      bodyBuilder;
  final String dataId;

  const _ReadingScreen(
      {super.key, required this.bodyBuilder, required this.dataId});

  @override
  Widget build(BuildContext context) => ActionScaffold(
        bodyBuilder: (context, controller) => BreakpointProvider(
          child: bodyBuilder(context, controller),
        ),
        floatingAction: PressedAction(
          name: 'Search',
          icon: Icon(Icons.auto_awesome_rounded),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AssistantScreen(
                  dataId: dataId,
                ),
              )),
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

class ReadingScreen extends StatelessWidget {
  final String dataId;
  final String? title;
  final String? source;
  final List<String>? writers;
  final String? publishTime;
  final String? visitCount;

  ReadingScreen(
      {super.key,
      required this.dataId,
      this.title,
      this.source,
      this.writers,
      this.publishTime,
      this.visitCount})
      : _viewModel = ReadingViewModel(dataId);

  final ReadingViewModel _viewModel;

  @override
  Widget build(BuildContext context) => FutureWidget(
        dataFuture: _viewModel.dataFuture,
        uncompletedWidget: _ReadingScreen(
          key: key,
          dataId: dataId,
          bodyBuilder: (context, _) => NewsScrollViewSkeleton(
            isLoading: true,
            title: title ?? _title,
            source: source,
            writers: writers,
            time: publishTime,
            visitCount: visitCount,
          ),
        ),
        dataBuilder: (context, data) => _ReadingScreen(
          key: key,
          dataId: dataId,
          bodyBuilder: (context, controller) => NewsScrollView(
            title: data.title,
            source: data.source,
            writers: data.writers,
            time: data.formattedPublishTime,
            visitCount: '${data.view}',
            content: data.content,
            loadImageUrl: _viewModel.loadImageUrl,
            loadFallbackImage: _viewModel.loadFallbackImage,
            controller: controller,
          ),
        ),
        errorBuilder: (context, _) => _ReadingScreen(
          key: key,
          dataId: dataId,
          bodyBuilder: (context, _) => NewsScrollViewSkeleton(
            isLoading: false,
            title: title ?? _title,
            source: source,
            writers: writers,
            time: publishTime,
            visitCount: visitCount,
            sliversTrailing: [
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
        ),
      );
}
