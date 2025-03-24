import 'spacing.dart';

class SliverAppBar {
  const SliverAppBar._();

  static const bottomPadding = 16.0;
  static const startPadding = 72.0;
  static const endPadding = Margin.compactMargin;
  static const horizontalPaddingWithoutLeading = Margin.mediumMargin;
}

class NavigationRail {
  const NavigationRail._();

  static const spacing = Padding.increment * 2;

  static const verticalPadding = 12.0;
  static const horizontalPadding = 6.0;

  static const width = 80.0;
  static const extendedWidth = 175.0;
}

class Pane {
  const Pane._();

  // https://m3.material.io/foundations/layout/applying-layout/expanded#3daf21e2-06f0-4c31-b346-fe4fb2432d00
  static const expandedWidth = 360.0;
  // https://m3.material.io/foundations/layout/applying-layout/large-extra-large#b542d9d8-6e19-4f20-a6e7-4998699c53c0
  static const largeWidth = 412.0;
  // https://m3.material.io/foundations/layout/applying-layout/large-extra-large#c2ed06a9-6986-4c3c-aa3a-265f744cc68c
  static const maxSideWidth = 400.0;
}
