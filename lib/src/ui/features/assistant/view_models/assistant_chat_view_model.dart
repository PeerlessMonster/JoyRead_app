import 'package:eventflux/eventflux.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/message.dart';
import '../../../../data/repositories/assistant.dart';

class AssistantChatViewModel extends ChangeNotifier {
  late final AssistantRepository _repository;

  AssistantChatViewModel() {
    _client = EventFlux.spawn();
    _repository = AssistantRepository(_client);
  }

  late final EventFlux _client;

  Stream<AssistantMessage>? answerStream;

  void loadAnswer(String question) {
    if (hasUserMessage) {
      answerStream = null;
    }

    _repository.loadAnswer(question, (dataStream) {
      answerStream = dataStream;
      notifyListeners();
    });
    messages.insert(0, UserMessage(question: question));

    if (!hasUserMessage) {
      hasUserMessage = true;
    }
    notifyListeners();
  }

  final messages = <Message>[];

  void saveAssistantMessage(AssistantMessage message) =>
      messages.insert(0, message);

  void reloadAnswer() {
    answerStream = null;
    notifyListeners();

    final latestUserMessage = messages.first as UserMessage;
    _repository.loadAnswer(latestUserMessage.question, (dataStream) {
      answerStream = dataStream;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _client.disconnect();
    super.dispose();
  }

  var hasUserMessage = false;
}
