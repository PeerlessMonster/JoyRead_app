import 'package:flutter/material.dart';

import '../../../../data/models/news_title.dart';
import '../../../core/shared/avatar.dart';
import '../../../core/themes/constants/dimension.dart' as dimension;
import '../../../core/themes/constants/spacing.dart' as spacing;
import '../../../widgets/chat_message.dart';
import '../../../widgets/dotted_progress_indicator.dart';
import '../../reading/views/reading_screen.dart';

class UserMessageWidget extends StatelessWidget {
  final Widget content;

  const UserMessageWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) => RowChatMessage(
        content: content,
        avatar: Image.asset(Avatar.user.assetName),
        alignment: RowChatMessageAlignment.end,
      );
}

class AssistantMessageWidget extends StatelessWidget {
  final Widget answer;
  final List<NewsTitle>? sources;

  AssistantMessageWidget({super.key, required this.answer, this.sources})
      : assert((sources != null && sources.isNotEmpty) || sources == null,
            'List of sources cannot be empty');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return RowChatMessage(
      content: sources == null
          ? answer
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacing.Padding.increment * 2,
              children: [
                answer,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sources!.indexed.map((record) {
                    final (index, source) = record;
                    return Chip(
                      avatar: Text(
                        '${index + 1}',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: colorScheme.tertiary,
                        ),
                      ),
                      label: Text(source.title),
                      onDeleted: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadingScreen(
                              dataId: source.id,
                            ),
                          )),
                      deleteButtonTooltipMessage: '阅读详情',
                      deleteIcon: Icon(Icons.read_more_rounded),
                      deleteIconColor:
                          colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      shape: const StadiumBorder(),
                    );
                  }).toList(),
                )
              ],
            ),
      avatar: Icon(Icons.auto_awesome_rounded),
      alignment: RowChatMessageAlignment.start,
    );
  }
}

class AssistantErrorMessageWidget extends StatelessWidget {
  final void Function() reloadAnswer;

  const AssistantErrorMessageWidget({super.key, required this.reloadAnswer});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AssistantMessageWidget(
      answer: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: spacing.Padding.increment * 2,
        children: [
          Text(
            'Unable to access network.',
            style: textTheme.bodyLarge,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
                end:
                    dimension.Card.horizontalPadding - spacing.Margin.allSides),
            child: FilledButton(
              onPressed: reloadAnswer,
              child: Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }
}

class AssistantThinkingMessageWidget extends StatelessWidget {
  const AssistantThinkingMessageWidget({super.key});

  @override
  Widget build(BuildContext context) => AssistantMessageWidget(
        answer: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing.Padding.increment * 1,
          children: [
            Text('思考中'),
            DottedProgressIndicator(),
          ],
        ),
      );
}

class AssistantOpenerMessageWidget extends StatelessWidget {
  final Widget? opener;
  final List<String>? suggestedQuestions;
  final void Function(String value)? onSent;

  AssistantOpenerMessageWidget(
      {super.key, this.opener, this.suggestedQuestions, this.onSent})
      : assert(opener != null || suggestedQuestions != null,
            'Any of opener or suggested questions should be passed'),
        assert(
            (suggestedQuestions != null && suggestedQuestions.isNotEmpty) ||
                suggestedQuestions == null,
            'List of suggested questions cannot be empty'),
        assert(
            (suggestedQuestions != null && onSent != null) ||
                (suggestedQuestions == null && onSent == null),
            'Sending function should be passed along with suggested questions');

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    if (opener != null) {
      items.add(opener!);
    }
    if (suggestedQuestions != null) {
      items.addAll([
        Text('你可以问我这些问题：'),
        ...suggestedQuestions!.map((question) => TextButton(
              onPressed: () => onSent!(question),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: spacing.Padding.spacingBetweenIconAndLabel,
                children: [
                  Text(question),
                  Icon(Icons.send_rounded),
                ],
              ),
            ))
      ]);
    }

    return AssistantMessageWidget(
      answer: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }
}
