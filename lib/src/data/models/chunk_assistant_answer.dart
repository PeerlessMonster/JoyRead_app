import 'news_title.dart';

sealed class ChunkAssistantAnswer {
  const ChunkAssistantAnswer();

  factory ChunkAssistantAnswer.fromJson(Map<String, dynamic> json) =>
      switch (json) {
        {
          'event': 'ANSWER',
          'markdown': String markdown,
        } =>
          ChunkAssistantAnswerText(markdown: markdown),
        {
          'event': 'SOURCE',
          'sources': List<dynamic> sources,
        } =>
          AssistantAnswerSource(sources: NewsTitle.fromJsonList(sources)),
        _ => throw const FormatException('Unexpected format of JSON'),
      };
}

class ChunkAssistantAnswerText extends ChunkAssistantAnswer {
  final String markdown;

  const ChunkAssistantAnswerText({required this.markdown});
}

class AssistantAnswerSource extends ChunkAssistantAnswer {
  final List<NewsTitle> sources;

  const AssistantAnswerSource({required this.sources});
}
