import 'package:eventflux/eventflux.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/message.dart';
import '../../../../data/repositories/assistant.dart';

class AssistantChatViewModel extends ChangeNotifier {
  final String? dataId;

  late final AssistantRepository _repository;

  AssistantChatViewModel(this.dataId) {
    _client = EventFlux.spawn();
    _repository = AssistantRepository(_client);
  }

  late final EventFlux _client;

  void _loadAnswer(String question) => _repository.loadAnswer(
        (error, lastData) {
          if (lastData != null) {
            _undoneAnswer = lastData;
          }

          _answerStream = Stream.error(error);
          notifyListeners();
        },
        (completedData) => messages.insert(0, completedData),
        (dataStream) {
          _answerStream = dataStream;
          notifyListeners();
        },
        question,
        dataId,
      );

  Stream<AssistantMessage>? _answerStream;
  Stream<AssistantMessage>? get answerStream => _answerStream;

  AssistantMessage? _undoneAnswer;
  AssistantMessage? get undoneAnswer => _undoneAnswer;

  void _initializeNewAnswer() {
    _answerStream = null;
    if (_undoneAnswer != null) {
      _undoneAnswer = null;
    }
  }

  void send(String question) {
    if (_hasUserMessage) {
      _initializeNewAnswer();
    }

    _loadAnswer(question);
    messages.insert(0, UserMessage(question: question));

    if (!_hasUserMessage) {
      _hasUserMessage = true;
    }
    notifyListeners();
  }

  final messages = <Message>[];

  void resend() {
    _initializeNewAnswer();
    notifyListeners();

    final latestUserMessage = messages.first as UserMessage;
    _loadAnswer(latestUserMessage.question);
  }

  @override
  void dispose() {
    _client.disconnect();
    super.dispose();
  }

  var _hasUserMessage = false;
  bool get hasUserMessage => _hasUserMessage;
}
