import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../data/models/user.dart';
import '../../../widgets/fade_out_container.dart';
import 'assistant_chat_box.dart';

void showAssistantSheet(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet(
    context: context,
    builder: (context) => FadeOutContainer(
      outColor: colorScheme.surface,
      position: FadeOutPosition.top,
      fadeHeight: 10,
      child: AssistantChatBox(
        opener: MarkdownBody(data: '# **${testUser.name}**，早上好！'),
        suggestedQuestions: const ['概括这篇文章的内容'],
      ),
    ),
    backgroundColor: colorScheme.surface,
    isDismissible: false,
    showDragHandle: true,
  );
}
