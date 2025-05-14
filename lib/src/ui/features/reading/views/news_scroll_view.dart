import 'package:flutter/material.dart';

import '../../../../data/models/news.dart';
import '../../../../utils/breakpoint.dart';
import '../../../core/breakpoint_state.dart';
import '../../../core/responsive_margin.dart';
import '../../../core/shared/background.dart';
import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../widgets/app_bar.dart';
import 'news_content_document.dart';
import 'news_detail_grid.dart';

const _spacing = spacing.Padding.increment * 10;

Widget _buildSpacer() => SliverToBoxAdapter(
      child: SizedBox(height: _spacing),
    );

class _HorizontalResponsiveSliverMargin extends StatelessWidget {
  final Widget sliver;

  const _HorizontalResponsiveSliverMargin({required this.sliver});

  @override
  Widget build(BuildContext context) => ResponsiveSliverMargin(
        margin: const ResponsiveEdgeInsets.symmetric(enableHorizontal: true),
        sliver: sliver,
      );
}

class NewsScrollView extends StatelessWidget {
  final String title;
  final String source;
  final List<String> writers;
  final String time;
  final String visitCount;
  final List<ParagraphBlock> content;
  final String Function(String filename) loadImageUrl;
  final Background Function() loadFallbackImage;
  final ScrollController? controller;

  const NewsScrollView(
      {super.key,
      required this.title,
      required this.source,
      required this.writers,
      required this.time,
      required this.visitCount,
      required this.content,
      required this.loadImageUrl,
      required this.loadFallbackImage,
      this.controller});

  @override
  Widget build(BuildContext context) => CustomScrollView(
        controller: controller,
        slivers: [
          _buildSliverAppBar(context, title),
          _HorizontalResponsiveSliverMargin(
            sliver: SliverToBoxAdapter(
              child: NewsDetailGrid(
                source: source,
                writers: writers,
                time: time,
                visitCount: visitCount,
              ),
            ),
          ),
          _buildSpacer(),
          _HorizontalResponsiveSliverMargin(
            sliver: NewsContentDocument(
              data: content,
              loadImageUrl: loadImageUrl,
              loadFallbackImage: loadFallbackImage,
              spacing: _spacing,
            ),
          ),
        ],
      );
}

class NewsScrollViewSkeleton extends StatelessWidget {
  final bool isLoading;
  final String title;
  final String? source;
  final List<String>? writers;
  final String? time;
  final String? visitCount;
  final List<Widget>? sliversTrailing;

  const NewsScrollViewSkeleton(
      {super.key,
      required this.isLoading,
      required this.title,
      this.source,
      this.writers,
      this.time,
      this.visitCount,
      this.sliversTrailing});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      _buildSliverAppBar(context, title),
      _HorizontalResponsiveSliverMargin(
        sliver: SliverToBoxAdapter(
          child: NewsDetailGridSkeleton(
            isLoading: isLoading,
            source: source,
            writers: writers,
            time: time,
            visitCount: visitCount,
          ),
        ),
      ),
      _buildSpacer(),
      _HorizontalResponsiveSliverMargin(
        sliver: NewsContentDocumentSkeleton(isLoading: isLoading),
      ),
    ];
    if (sliversTrailing != null) {
      items.addAll(sliversTrailing!);
    }
    return CustomScrollView(slivers: items);
  }
}

Widget _buildSliverAppBar(BuildContext context, String title) {
  final breakpoint = BreakpointState.of(context);
  return breakpoint <= Breakpoint.compact
      ? FlexibleSliverAppBar(title: title)
      : FlexibleSliverAppBarWithoutLeading(title: title);
}
