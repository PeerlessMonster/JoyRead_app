import '../../utils/time.dart' as time;

class News {
  final String title;
  final DateTime publishUtc;
  final String source;
  final List<String> writers;
  final List<ParagraphBlock> content;

  const News(
      {required this.title,
      required this.publishUtc,
      required this.source,
      required this.writers,
      required this.content});

  factory News.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'title': String title,
          'publishUTCEpochMilli': String publishUtcMillisecondsSinceEpoch,
          'source': String source,
          'writers': List<dynamic> writers,
          'content': List<dynamic> paragraphs,
        } =>
          News(
              title: title,
              publishUtc: time.parse(publishUtcMillisecondsSinceEpoch),
              source: source,
              writers: writers.cast<String>(),
              content: ParagraphBlock.fromJsonList(paragraphs)),
        _ => throw const FormatException('Unexpected JSON format'),
      };
}

abstract class Block {
  const Block();
}

sealed class ParagraphBlock extends Block {
  const ParagraphBlock();

  factory ParagraphBlock.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'type': 'HEADING',
        'text': String text,
        'level': int level,
      } =>
        HeadingBlock(text: text, level: level),
      {
        'type': 'IMAGE',
        'filename': String filename,
      } =>
        ImageBlock(filename: filename),
      {
        'type': 'IMAGE_DESCRIPTION',
        'spans': List<dynamic> spans,
      } =>
        ImageDescriptionBlock(spans: SpanBlock.fromJsonList(spans)),
      {
        'type': 'CONTEXT',
        'paragraphs': List<dynamic> paragraphs,
      } =>
        ContextBlock(paragraphs: ParagraphBlock.fromJsonList(paragraphs)),
      {
        'type': 'QUOTE',
        'paragraphs': List<dynamic> paragraphs,
      } =>
        QuoteBlock(paragraphs: ParagraphBlock.fromJsonList(paragraphs)),
      {
        'type': 'BODY',
        'spans': List<dynamic> spans,
      } =>
        BodyBlock(spans: SpanBlock.fromJsonList(spans)),
      _ => throw const FormatException('Unexpected format of Paragraph'),
    };
  }

  static List<ParagraphBlock> fromJsonList(List<dynamic> jsonList) => jsonList
      .cast<Map<String, dynamic>>()
      .map((json) => ParagraphBlock.fromJson(json))
      .toList();
}

class HeadingBlock extends ParagraphBlock {
  final String text;
  final int level;

  const HeadingBlock({required this.text, required this.level})
      : assert(level > 0, 'Level of heading should be positive integer');
}

class ImageBlock extends ParagraphBlock {
  final String filename;

  const ImageBlock({required this.filename});
}

class ImageDescriptionBlock extends ParagraphBlock {
  final List<SpanBlock> spans;

  const ImageDescriptionBlock({required this.spans});
}

class ContextBlock extends ParagraphBlock {
  final List<ParagraphBlock> paragraphs;

  const ContextBlock({required this.paragraphs});
}

class QuoteBlock extends ParagraphBlock {
  final List<ParagraphBlock> paragraphs;

  const QuoteBlock({required this.paragraphs});
}

class BodyBlock extends ParagraphBlock {
  final List<SpanBlock> spans;

  const BodyBlock({required this.spans});
}

class SpanBlock extends Block {
  final String text;
  final SpanStyle style;

  const SpanBlock({required this.text, required this.style});

  factory SpanBlock.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'type': 'SPAN',
          'text': String text,
          'style': String style,
        } =>
          SpanBlock(
              text: text,
              style: switch (style) {
                'BOLD' => SpanStyle.bold,
                'ITALIC' => SpanStyle.italic,
                'COLORED' => SpanStyle.colored,
                'NORMAL' => SpanStyle.normal,
                'ORDER' => SpanStyle.order,
                'SIGN' => SpanStyle.sign,
                _ => throw FormatException('No enum named $style in TextStyle'),
              }),
        _ => throw const FormatException('Unexpected format of Span'),
      };

  static List<SpanBlock> fromJsonList(List<dynamic> jsonList) => jsonList
      .cast<Map<String, dynamic>>()
      .map((json) => SpanBlock.fromJson(json))
      .toList();
}

enum SpanStyle { sign, order, normal, bold, italic, colored }
