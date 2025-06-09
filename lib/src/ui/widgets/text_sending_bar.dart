import 'package:flutter/material.dart';

class TextSendingBar extends StatefulWidget {
  final void Function(String value) onSent;
  final String? hintText;

  const TextSendingBar({super.key, required this.onSent, this.hintText});

  @override
  State<TextSendingBar> createState() => _TextSendingBarState();
}

class _TextSendingBarState extends State<TextSendingBar> {
  var hasText = false;

  late final TextEditingController _controller;

  void _handleTextChange() {
    final isTextExisting = _controller.text.isNotEmpty;
    if (isTextExisting != hasText) {
      setState(() {
        hasText = isTextExisting;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _controller.addListener(_handleTextChange);
  }

  void _onSubmitted() {
    widget.onSent(_controller.text);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onEditingComplete: () {
                if (_controller.text.isEmpty) {
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
