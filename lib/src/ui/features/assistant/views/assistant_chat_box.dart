import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../data/models/message.dart';
import '../../../core/stream_widget.dart';
import '../../../widgets/chat_box.dart';
import '../view_models/assistant_chat_view_model.dart';
import 'message_widget.dart';

class AssistantChatBox extends StatefulWidget {
  final Widget? opener;
  final List<String>? suggestedQuestions;
  final String? dataId;

  const AssistantChatBox(
      {super.key, this.opener, this.suggestedQuestions, this.dataId});

  @override
  State<AssistantChatBox> createState() => _AssistantChatBoxState();
}

class _AssistantChatBoxState extends State<AssistantChatBox> {
  late final _viewModel = AssistantChatViewModel(widget.dataId);

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => ChatBox(
          hintText: 'Ask me anything.',
          onSent: _viewModel.send,
          children: [
            StreamWidget(
              stream: _viewModel.answerStream,
              unconnectedBuilder: (context, _) => _viewModel.hasUserMessage
                  ? AssistantThinkingMessageWidget()
                  : const SizedBox.shrink(),
              waitingWidget: AssistantThinkingMessageWidget(),
              activeBuilder: (context, data) => AssistantMessageWidget(
                answer: MarkdownBody(data: data.answer),
                sources: data.sources,
              ),
              doneBuilder: (context, data) => AssistantMessageWidget(
                answer: MarkdownBody(data: data.answer),
                sources: data.sources,
              ),
              errorBuilder: (context, _) {
                final undoneAnswer = _viewModel.undoneAnswer;
                return AssistantErrorMessageWidget(
                  answer: undoneAnswer == null
                      ? null
                      : MarkdownBody(data: undoneAnswer.answer),
                  reloadAnswer: _viewModel.resend,
                );
              },
            ),
            ..._viewModel.messages.map((message) => switch (message) {
                  UserMessage() => UserMessageWidget(
                      content: MarkdownBody(data: message.question),
                    ),
                  AssistantMessage() => AssistantMessageWidget(
                      answer: MarkdownBody(data: message.answer),
                      sources: message.sources,
                    ),
                }),
            AssistantOpenerMessageWidget(
              opener: widget.opener,
              suggestedQuestions: widget.suggestedQuestions,
              onSent: _viewModel.send,
            ),
          ],
        ),
      );
}
