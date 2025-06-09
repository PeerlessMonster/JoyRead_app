import 'package:flutter/material.dart';

import '../../../core/breakpoint_state.dart';
import '../../../core/future_widget.dart';
import '../../../core/pressed_action.dart';
import '../../../widgets/action_scaffold.dart';
import '../../assistant/views/assistant_sheet.dart';
import '../view_models/extensions.dart';
import '../view_models/reading_view_model.dart';
import 'news_scroll_view.dart';

const _title = '阅读详情';

class _ReadingScreenLayout extends StatelessWidget {
  final Widget Function(BuildContext context, ScrollController controller)
      bodyBuilder;
  final String dataId;

  const _ReadingScreenLayout(
      {super.key, required this.bodyBuilder, required this.dataId});

  @override
  Widget build(BuildContext context) => ActionScaffold(
        bodyBuilder: (context, controller) => BreakpointProvider(
          child: bodyBuilder(context, controller),
        ),
        floatingAction: PressedAction(
          name: 'Search',
          icon: Icon(Icons.auto_awesome_rounded),
          onPressed: () => showAssistantSheet(context),
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

class ReadingScreen extends StatefulWidget {
  final String dataId;
  final String? title;
  final String? source;
  final List<String>? writers;
  final String? publishTime;
  final String? visitCount;

  const ReadingScreen(
      {super.key,
      required this.dataId,
      this.title,
      this.source,
      this.writers,
      this.publishTime,
      this.visitCount});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late final _viewModel = ReadingViewModel(widget.dataId);

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => FutureWidget(
          dataFuture: _viewModel.dataFuture,
          uncompletedWidget: _ReadingScreenLayout(
            key: widget.key,
            dataId: widget.dataId,
            bodyBuilder: (context, _) => NewsScrollViewSkeleton(
              isLoading: true,
              title: widget.title ?? _title,
              source: widget.source,
              writers: widget.writers,
              time: widget.publishTime,
              visitCount: widget.visitCount,
            ),
          ),
          dataBuilder: (context, data) => _ReadingScreenLayout(
            key: widget.key,
            dataId: widget.dataId,
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
          errorBuilder: (context, _) => _ReadingScreenLayout(
            key: widget.key,
            dataId: widget.dataId,
            bodyBuilder: (context, _) => NewsScrollViewSkeleton(
              isLoading: false,
              title: widget.title ?? _title,
              source: widget.source,
              writers: widget.writers,
              time: widget.publishTime,
              visitCount: widget.visitCount,
              sliversTrailing: [
                SliverToBoxAdapter(
                  child: Center(
                    child: FilledButton.icon(
                      icon: Icon(Icons.refresh_rounded),
                      label: Text('Retry'),
                      onPressed: _viewModel.reload,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
