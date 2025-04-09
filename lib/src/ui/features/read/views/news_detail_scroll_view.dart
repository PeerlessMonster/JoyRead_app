import 'package:flutter/material.dart';

import '../../../../data/models/news.dart';
import '../../../core/responsive_margin.dart';
import '../../../core/shared/background.dart';
import '../../../core/themes/constants/spacing.dart' as spacing;
import 'news_content_document.dart';
import 'news_meta_grid.dart';

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

List<Widget> buildDetailScrollView(
        String source,
        List<String> writers,
        String time,
        String visitCount,
        List<ParagraphBlock> content,
        String Function(String filename) loadImageUrl,
        Background Function() loadFallbackImage) =>
    [
      _HorizontalResponsiveSliverMargin(
        sliver: SliverToBoxAdapter(
          child: NewsMetaGrid(
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
      )
    ];

List<Widget> buildDetailScrollViewSkeleton(bool isLoading, String? source,
        List<String>? writers, String? time, String? visitCount) =>
    [
      _HorizontalResponsiveSliverMargin(
        sliver: SliverToBoxAdapter(
          child: NewsMetaGridSkeleton(
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
        sliver: NewsContentDocumentSkeleton(
          isLoading: isLoading,
        ),
      ),
    ];
