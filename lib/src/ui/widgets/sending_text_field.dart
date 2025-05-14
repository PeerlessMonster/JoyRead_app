import 'package:flutter/material.dart';

class SendingTextField extends StatelessWidget {
  final void Function(String value) onSent;
  final String? hintText;

  SendingTextField({super.key, required this.onSent, this.hintText});

  final _controller = TextEditingController();

  void _onSubmitted() {
    onSent(_controller.text);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onEditingComplete: _onSubmitted,
              maxLines: null,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: _controller.clear,
                  tooltip: '清除',
                  icon: Icon(Icons.clear_rounded),
                ),
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              textInputAction: TextInputAction.send,
              autofocus: true,
            ),
          ),
          IconButton.filled(
            onPressed: _onSubmitted,
            tooltip: '发送',
            icon: Icon(Icons.send_rounded),
          ),
        ],
      );
}
