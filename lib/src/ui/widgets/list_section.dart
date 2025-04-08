import 'package:flutter/material.dart';

import '../core/themes/constants/dimension.dart' as dimension;

enum ListSectionDividerIndentBehavior { none, contentAligned, leadingSkipped }

enum ListSectionDividerEndIndentBehavior { none, contentAligned }

class ListSection extends StatelessWidget {
  final List<Widget> children;
  final Widget? header;
  final Widget? footer;
  final ListSectionDividerIndentBehavior dividerIndentBehavior;
  final ListSectionDividerEndIndentBehavior dividerEndIndentBehavior;

  const ListSection(
      {super.key,
      this.header,
      this.footer,
      this.dividerIndentBehavior = ListSectionDividerIndentBehavior.none,
      this.dividerEndIndentBehavior = ListSectionDividerEndIndentBehavior.none,
      required this.children});

  Widget _buildDivider() {
    final indent = switch (dividerIndentBehavior) {
      ListSectionDividerIndentBehavior.none => .0,
      ListSectionDividerIndentBehavior.contentAligned =>
        dimension.ListTile.contentHorizontalPadding,
      ListSectionDividerIndentBehavior.leadingSkipped =>
        dimension.ListTile.leadingWidth,
    };
    final endIndent = switch (dividerEndIndentBehavior) {
      ListSectionDividerEndIndentBehavior.none => .0,
      ListSectionDividerEndIndentBehavior.contentAligned =>
        dimension.ListTile.contentHorizontalPadding,
    };

    return Divider(
      height: 2,
      indent: indent,
      endIndent: endIndent,
    );
  }

  List<Widget> _buildListRows() {
    final items = <Widget>[];

    final length = children.length;
    for (var i = 0; i < length; i++) {
      items.add(children[i]);

      if (i < length - 1) {
        items.add(_buildDivider());
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    if (header != null) {
      items.add(header!);
    }
    items.addAll(_buildListRows());
    if (footer != null) {
      items.add(footer!);
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }
}
