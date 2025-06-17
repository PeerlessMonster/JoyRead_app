import 'package:flutter/material.dart';

import '../core/text_editing_value_state_mixin.dart';
import '../core/themes/constants/dimension.dart' as dimension;

class SearchField extends StatefulWidget {
  final void Function(String query) onSearch;

  const SearchField({super.key, required this.onSearch});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField>
    with TextEditingValueStateMixin {
  static const _duration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SearchBar(
      controller: controller,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        tooltip: '返回',
        icon: Icon(Icons.arrow_back),
      ),
      trailing: [
        AnimatedScale(
          scale: hasText ? 1 : 0,
          duration: _duration,
          child: IconButton(
            onPressed: () {
              setState(() {
                hasText = false;
              });
              controller.clear();
            },
            tooltip: '清除',
            icon: Icon(Icons.clear_rounded),
          ),
        ),
        SizedBox(
          height: dimension.IconButton.shrinkWrapTapTargetSize,
          child: VerticalDivider(color: colorScheme.outline),
        ),
        IconButton(
          onPressed: hasText ? () => widget.onSearch(controller.text) : null,
          tooltip: '搜索',
          icon: Icon(Icons.search_rounded),
        ),
      ],
      onSubmitted: (value) {
        if (value.isEmpty) {
          return;
        }
        widget.onSearch(value);
      },
      autoFocus: true,
      textInputAction: TextInputAction.search,
    );
  }
}
