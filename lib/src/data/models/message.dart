import 'news_title.dart';

sealed class Message {
  const Message();
}

class UserMessage extends Message {
  final String question;

  const UserMessage({required this.question});
}

class AssistantMessage extends Message {
  final String answer;
  final List<NewsTitle>? sources;

  const AssistantMessage({required this.answer, this.sources});
}
