import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../data/models/user.dart';
import '../../../core/breakpoint_state.dart';
import '../../../widgets/app_bar.dart';
import 'assistant_chat_box.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBarWithActions(
          title: Text('小悦'),
          actions: [
            IconButton(
              onPressed: () {},
              tooltip: '设置',
              icon: Icon(Icons.settings_rounded),
            ),
          ],
        ),
        drawer: const Drawer(),
        body: SafeArea(
          child: BreakpointProvider(
            child: AssistantChatBox(
              opener: MarkdownBody(data: '# **${testUser.name}**，下午好！'),
              suggestedQuestions: const ['最新资讯', '今日热门资讯', '本周热门资讯'],
            ),
          ),
        ),
      );
}
