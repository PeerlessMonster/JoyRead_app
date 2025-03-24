import 'package:flutter/material.dart';

import '../../../core/breakpoint_state.dart';
import '../../../core/future_widget.dart';
import '../../../core/pressed_action.dart';
import '../../../core/responsive_margin.dart';
import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../widgets/adaptive_action_scaffold.dart';
import '../../../widgets/sliver_app_bar.dart';
import '../view_models/extensions.dart';
import '../view_models/read_screen.dart';
import 'content_document.dart';
import 'detail_container.dart';

const _spacing = spacing.Padding.increment * 10;

class _ReadScreen extends StatelessWidget {
  final String title;
  final Widget detailContainer;
  final Widget contentDocument;

  const _ReadScreen(
      {super.key,
      required this.title,
      required this.detailContainer,
      required this.contentDocument});

  ResponsiveEdgeInsets _buildMargin() =>
      const ResponsiveEdgeInsets.symmetric(applyHorizontal: true);

  @override
  Widget build(BuildContext context) => AdaptiveActionScaffold(
        key: key,
        narrowScreenBody: BreakpointProvider(
          child: CustomScrollView(slivers: [
            FlexibleSliverAppBar(
              title: title,
            ),
            ResponsiveSliverMargin(
              margin: _buildMargin(),
              sliver: SliverToBoxAdapter(
                child: detailContainer,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: _spacing,
              ),
            ),
            ResponsiveSliverMargin(
              margin: _buildMargin(),
              sliver: contentDocument,
            ),
          ]),
        ),
        wideScreenBody: BreakpointProvider(
          child: CustomScrollView(slivers: [
            FlexibleSliverAppBarWithoutLeading(
              title: title,
            ),
            ResponsiveSliverMargin(
              margin: _buildMargin(),
              sliver: SliverToBoxAdapter(
                child: detailContainer,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: _spacing,
              ),
            ),
            ResponsiveSliverMargin(
              margin: _buildMargin(),
              sliver: contentDocument,
            ),
          ]),
        ),
        floatingAction: PressedAction(
          name: 'Search',
          icon: Icon(Icons.search_rounded),
          onPressed: () {},
        ),
        primaryActions: [
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
        ],
        secondaryActions: [
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
        ],
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
      required this.title,
      this.source,
      this.writers,
      this.publishTime})
      : _viewModel = ReadScreenViewModel(dataId);

  final ReadScreenViewModel _viewModel;

  @override
  Widget build(BuildContext context) => FutureWidget(
        dataFuture: _viewModel.newsFuture,
        uncompletedWidget: _ReadScreen(
          key: key,
          title: title,
          detailContainer: DetailContainerSkeleton(
            isLoading: true,
            source: source,
            writers: writers,
            time: publishTime,
          ),
          contentDocument: ContentDocumentSkeleton(
            isLoading: true,
          ),
        ),
        dataBuilder: (context, data) => _ReadScreen(
          key: key,
          title: title,
          detailContainer: DetailContainer(
            source: data.source,
            writers: data.writers,
            time: data.formattedPublishTime,
          ),
          contentDocument: ContentDocument(
            data: data.content,
            loadImageUrl: _viewModel.loadImageUrl,
            loadFallbackImage: _viewModel.loadFallbackImage,
            spacing: _spacing,
          ),
        ),
        errorBuilder: (context, _) => _ReadScreen(
          key: key,
          title: title,
          detailContainer: DetailContainerSkeleton(
            isLoading: false,
            source: source,
            writers: writers,
            time: publishTime,
          ),
          contentDocument: ContentDocumentSkeleton(
            isLoading: false,
          ),
        ),
      );
}
