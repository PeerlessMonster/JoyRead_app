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

  void loadAnswer(String question,
          void Function(Stream<AssistantMessage> dataStream) onData) =>
      postChat(
        _client,
        (result) {
          switch (result) {
            case Ok():
              final responseBody = result.value;

              var answer = '';
              List<NewsTitle>? sources;

              final dataStream = responseBody.map((event) {
                final data = event.data;
                return jsonDecodeTo(data, ChunkAssistantAnswer.fromJson);
              }).map((data) {
                switch (data) {
                  case AnswerTextChunk():
                    answer += data.markdown;
                    return AssistantMessage(answer: answer, sources: sources);

                  case AnswerSource():
                    sources = data.sources;
                    return AssistantMessage(answer: answer, sources: sources);
                }
              });
              onData(dataStream);

            case Error():
              throw result.error;
          }
        },
        question: question,
        userId: testUser.id,
      );
}
