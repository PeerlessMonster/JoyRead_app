import '../../../../utils/breakpoint.dart';

class Icon {
  const Icon._();

  static const size = 24.0;
}

class CircleAvatar {
  const CircleAvatar._();

  static const size = 40.0;
}

class IconButton {
  const IconButton._();

  static const shrinkWrapTapTargetSize = 40.0;
}

class Banner {
  const Banner._();

  static const height = 52.0;
  static const heightPlusDivider = height + 2.0;
  static final floatingWidth =
      Breakpoint.medium.screenWidthRange.start - NavigationRail.extendedWidth;
}

class ListTile {
  const ListTile._();

  static const contentVerticalPadding = 10.0;
  static const contentHorizontalPadding = 16.0;

  static const leadingWidth = 40.0;
}

class Card {
  const Card._();

  static const horizontalPadding = 16.0;
}

class SliverAppBar {
  const SliverAppBar._();

  static const bottomPadding = 16.0;
  static const startPadding = 72.0;
}

class BottomAppBar {
  const BottomAppBar._();

  static const verticalPadding = 12.0;
  static const horizontalPadding = 16.0;

  static const height = 80.0;
}

class NavigationRail {
  const NavigationRail._();

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
