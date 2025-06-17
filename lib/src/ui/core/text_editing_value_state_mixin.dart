import 'package:flutter/material.dart';

/// A mixin managing the state of text in a [TextEditingController].
///
/// Just pass [controller], and [hasText] will tell whether text exists in the
/// controller.
mixin TextEditingValueStateMixin<T extends StatefulWidget> on State<T> {
  var hasText = false;

  @protected
  late final TextEditingController controller;

  void _handleTextChange() {
    final isTextExisting = controller.text.isNotEmpty;
    if (isTextExisting != hasText) {
      setState(() {
        hasText = isTextExisting;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
    controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
