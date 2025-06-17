import 'package:flutter/material.dart';

import '../core/text_editing_value_state_mixin.dart';

class TextSendingBar extends StatefulWidget {
  final void Function(String value) onSent;
  final String? hintText;

  const TextSendingBar({super.key, required this.onSent, this.hintText});

  @override
  State<TextSendingBar> createState() => _TextSendingBarState();
}

class _TextSendingBarState extends State<TextSendingBar>
    with TextEditingValueStateMixin {
  void _onSubmitted() {
    widget.onSent(controller.text);

    controller.clear();
  }

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onEditingComplete: () {
                if (controller.text.isEmpty) {
                  return;
                }
                _onSubmitted();
              },
              maxLines: null,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              textInputAction: TextInputAction.send,
              autofocus: true,
            ),
          ),
          IconButton.filled(
            onPressed: hasText ? _onSubmitted : null,
            tooltip: '发送',
            icon: Icon(Icons.send_rounded),
          ),
        ],
      );
}
