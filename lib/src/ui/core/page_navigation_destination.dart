import 'package:flutter/material.dart';

/// Data class of page navigation.
///
/// Can be used by some of the widgets include:
///
///   * [NavigationDestination]
///   * [NavigationRailDestination]
class PageNavigationDestination {
  final String name;
  final Icon icon;

  const PageNavigationDestination({required this.name, required this.icon});
}
