import 'package:eventflux/eventflux.dart';

import '../../utils/error_handling.dart';
import '../../utils/json.dart';
import '../models/chunk_assistant_answer.dart';
import '../models/message.dart';
import '../models/news_title.dart';
import '../models/user.dart';
import '../services/assistant.dart';

class AssistantRepository {
  final EventFlux _client;

  AssistantRepository(this._client);

  void loadAnswer(
      void Function(Exception error, AssistantMessage? lastData) onError,
      void Function(AssistantMessage completedData) onDone,
      void Function(Stream<AssistantMessage> dataStream) onData,
      String question,
      [String? newsId]) {
    var answer = '';
    List<NewsTitle>? sources;

    postQuestion(
      _client,
      () {
        final completedData =
            AssistantMessage(answer: answer, sources: sources);
        onDone(completedData);
      },
      (result) {
        switch (result) {
          case Ok():
            final responseBody = result.value;

            final dataStream = responseBody.map((event) {
              final data = event.data;
              final chunkAnswer =
                  jsonDecodeTo(data, ChunkAssistantAnswer.fromJson);

              switch (chunkAnswer) {
                case ChunkAssistantAnswerText():
                  answer += chunkAnswer.markdown;

                case AssistantAnswerSource():
                  sources = chunkAnswer.sources;
              }
              return AssistantMessage(answer: answer, sources: sources);
            });
            onData(dataStream);

          case Error():
            final error = result.error;

            final lastData = answer.isEmpty
                ? null
                : AssistantMessage(answer: answer, sources: sources);
            onError(error, lastData);
        }
      },
      newsId: newsId,
      question: question,
      userId: testUser.id,
    );
  }
}
