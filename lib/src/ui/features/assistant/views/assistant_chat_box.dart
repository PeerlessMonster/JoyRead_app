import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../data/models/message.dart';
import '../../../core/stream_widget.dart';
import '../../../widgets/chat_box.dart';
import '../view_models/assistant_chat_view_model.dart';
import 'message_widget.dart';

class AssistantChatBox extends StatelessWidget {
  final Widget? opener;
  final List<String>? suggestedQuestions;

  AssistantChatBox({super.key, this.opener, this.suggestedQuestions});

  final _viewModel = AssistantChatViewModel();

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => ChatBox(
          hintText: 'Ask me anything.',
          onSent: _viewModel.loadAnswer,
          children: [
            StreamWidget(
              stream: _viewModel.answerStream,
              unconnectedBuilder: (context, _) => _viewModel.hasUserMessage
                  ? AssistantThinkingMessageWidget()
                  : const SizedBox.shrink(),
              waitingWidget: AssistantThinkingMessageWidget(),
              activeBuilder: (context, data) => AssistantMessageWidget(
                answer: MarkdownBody(
                  data: data.answer,
                ),
                sources: data.sources,
              ),
              doneBuilder: (context, data) {
                _viewModel.saveAssistantMessage(data);

                return AssistantMessageWidget(
                  answer: MarkdownBody(
                    data: data.answer,
                  ),
                  sources: data.sources,
                );
              },
              errorBuilder: (context, _) => AssistantErrorMessageWidget(
                reloadAnswer: _viewModel.reloadAnswer,
              ),
            ),
            ..._viewModel.messages.map((message) => switch (message) {
                  UserMessage() => UserMessageWidget(
                      content: Text(message.question),
                    ),
                  AssistantMessage() => AssistantMessageWidget(
                      answer: MarkdownBody(
                        data: message.answer,
                      ),
                      sources: message.sources,
                    ),
                }),
            AssistantOpenerMessageWidget(
              opener: opener,
              suggestedQuestions: suggestedQuestions,
              onSent: _viewModel.loadAnswer,
            ),
          ],
        ),
      );
}
