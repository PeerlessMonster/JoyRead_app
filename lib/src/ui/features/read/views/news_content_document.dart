import 'package:flutter/material.dart';

import '../../../../data/models/news.dart';
import '../../../core/shared/background.dart';
import '../../../widgets/skeleton.dart';
import 'block_widget.dart';

class NewsContentDocument extends StatelessWidget {
  final List<ParagraphBlock> data;
  final String Function(String filename) loadImageUrl;
  final Background Function() loadFallbackImage;
  final double spacing;

  const NewsContentDocument(
      {super.key,
      required this.data,
      required this.loadImageUrl,
      required this.loadFallbackImage,
      required this.spacing});

  Widget _buildBlockWidget(ParagraphBlock paragraphBlock) {
    switch (paragraphBlock) {
      case HeadingBlock():
        return HeadingBlockWidget(
          text: paragraphBlock.text,
          level: paragraphBlock.level,
        );

      case ImageBlock():
        final url = loadImageUrl(paragraphBlock.filename);
        final fallbackImage = loadFallbackImage();
        return ImageBlockWidget(
          url: url,
          fallbackImageAssetName: fallbackImage.assetName,
          foregroundColor: fallbackImage.foregroundColor,
        );

      case ImageDescriptionBlock():
        return ImageDescriptionBlockWidget(
          spans: paragraphBlock.spans,
        );

      case ContextBlock():
        final paragraphs = paragraphBlock.paragraphs;
        return ContextBlockWidget(
          children: _buildParagraphsBlock(paragraphs),
        );

      case QuoteBlock():
        final paragraphs = paragraphBlock.paragraphs;
        return QuoteBlockWidget(
          children: _buildParagraphsBlock(paragraphs),
        );

      case BodyBlock():
        return BodyBlockWidget(
          spans: paragraphBlock.spans,
        );
    }
  }

  List<Widget> _buildParagraphsBlock(List<ParagraphBlock> paragraphs) {
    final items = <Widget>[];

    final length = paragraphs.length;
    for (var i = 0; i < length; i++) {
      final item = _buildBlockWidget(paragraphs[i]);
      items.add(i < length - 1
          ? Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: item,
            )
          : item);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: _buildBlockWidget(data[index]),
          ),
          childCount: data.length,
        ),
      );
}

class NewsContentDocumentSkeleton extends StatelessWidget {
  final bool isLoading;

  const NewsContentDocumentSkeleton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: MultiTextSkeleton(
          heightAsLineCount: 6,
          playAnimation: isLoading,
        ),
      );
}
