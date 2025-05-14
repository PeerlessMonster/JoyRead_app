import 'news_title.dart';

sealed class ChunkAssistantAnswer {
  const ChunkAssistantAnswer();

  factory ChunkAssistantAnswer.fromJson(Map<String, dynamic> json) =>
      switch (json) {
        {
          'event': 'ANSWER',
          'markdown': String text,
        } =>
          AnswerTextChunk(markdown: text),
        {
          'event': 'SOURCE',
          'sources': List<dynamic> sources,
        } =>
          AnswerSource(sources: NewsTitle.fromJsonList(sources)),
        _ => throw const FormatException('Unexpected format of JSON'),
      };
}

class AnswerTextChunk extends ChunkAssistantAnswer {
  final String markdown;

  const AnswerTextChunk({required this.markdown});
}

class AnswerSource extends ChunkAssistantAnswer {
  final List<NewsTitle> sources;

  const AnswerSource({required this.sources});
}
