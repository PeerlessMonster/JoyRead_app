import '../../utils/time.dart' as time;

class News {
  final String title;
  final DateTime publishUtc;
  final int view;
  final String source;
  final List<String> writers;
  final List<ParagraphBlock> content;

  const News(
      {required this.title,
      required this.publishUtc,
      required this.view,
      required this.source,
      required this.writers,
      required this.content});

  factory News.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'title': String title,
          'publishUTCEpochMilli': String publishUtcMillisecondsSinceEpoch,
          'view': int view,
          'source': String source,
          'writers': List<dynamic> writers,
          'content': List<dynamic> paragraphs,
        } =>
          News(
              title: title,
              publishUtc: time.parse(publishUtcMillisecondsSinceEpoch),
              view: view,
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

  factory ParagraphBlock.fromJson(Map<String, dynamic> json) => switch (json) {
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
          'type': 'ANNOTATION',
          'spans': List<dynamic> spans,
        } =>
          AnnotationBlock(spans: SpanBlock.fromJsonList(spans)),
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
          BodyBlock(
              leading: json.containsKey('leading')
                  ? LeadingBlock.fromJson(
                      json['leading'] as Map<String, dynamic>)
                  : null,
              spans: SpanBlock.fromJsonList(spans)),
        _ => throw const FormatException('Unexpected format of Paragraph'),
      };

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

class AnnotationBlock extends ParagraphBlock {
  final List<SpanBlock> spans;

  const AnnotationBlock({required this.spans});
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
  final LeadingBlock? leading;
  final List<SpanBlock> spans;

  const BodyBlock({this.leading, required this.spans});
}

class LeadingBlock extends Block {
  final String text;
  final LeadingStyle style;

  const LeadingBlock({required this.text, required this.style});

  factory LeadingBlock.fromJson(Map<String, dynamic> json) => switch (json) {
        {'type': 'LEADING', 'text': String text, 'style': String style} =>
          LeadingBlock(
              text: text,
              style: switch (style) {
                'SIGN' => LeadingStyle.sign,
                'ORDER' => LeadingStyle.order,
                _ =>
                  throw FormatException('No enum named $style in LeadingStyle'),
              }),
        _ => throw const FormatException('Unexpected format of Leading'),
      };
}

enum LeadingStyle { sign, order }

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
                'BOLD_COLORED' => SpanStyle.boldColored,
                'ITALIC_BOLD' => SpanStyle.italicBold,
                'NORMAL' => SpanStyle.normal,
                _ => throw FormatException('No enum named $style in TextStyle'),
              }),
        _ => throw const FormatException('Unexpected format of Span'),
      };

  static List<SpanBlock> fromJsonList(List<dynamic> jsonList) => jsonList
      .cast<Map<String, dynamic>>()
      .map((json) => SpanBlock.fromJson(json))
      .toList();
}

enum SpanStyle { normal, bold, italic, colored, boldColored, italicBold }
