import 'dart:math';

import 'package:flutter/material.dart';

class Background {
  final String filename;
  String get assetName => 'assets/$filename';
  final Color onBackground;

  const Background({required this.filename, required this.onBackground});
}

const _backgrounds = [
  Background(
    filename: 'benaja-germann-1JRZN1K8cGo-unsplash.jpg',
    onBackground: Colors.white,
  ),
  Background(
    filename: 'benaja-germann-wKOX1F0wecc-unsplash.jpg',
    onBackground: Colors.white,
  ),
  Background(
    filename: 'colin-watts-O_vfjjh6t3k-unsplash.jpg',
    onBackground: Colors.black,
  ),
  Background(
    filename: 'darren-lawrence-Ad7-qVkGy7Y-unsplash.jpg',
    onBackground: Colors.black,
  ),
  Background(
    filename: 'gabriele-merlino-oiys4LLfO5M-unsplash.jpg',
    onBackground: Colors.white,
  ),
  Background(
    filename: 'ingmar-h--O8b5mIORMk-unsplash.jpg',
    onBackground: Colors.white,
  ),
  Background(
      filename: 'junel-mujar-51jzoz1dsro-unsplash.jpg',
      onBackground: Colors.black),
  Background(
    filename: 'marek-piwnicki-HxPkohFqDGY-unsplash.jpg',
    onBackground: Colors.white,
  ),
  Background(
    filename: 'pascal-debrunner-Bd-PwE6KnSc-unsplash.jpg',
    onBackground: Colors.black,
  ),
  Background(
    filename: 'steve-gribble-MUoP6i9w870-unsplash.jpg',
    onBackground: Colors.white,
  )
];

class BackgroundRandom {
  static final _random = Random();

  static Background nextAsset() {
    final index = _random.nextInt(_backgrounds.length);
    return _backgrounds[index];
  }

  static List<Background> nextDistinctAssets(int count) {
    final indexs = <int>{};
    while (indexs.length < count) {
      indexs.add(_random.nextInt(_backgrounds.length));
    }
    return indexs.map((index) => _backgrounds[index]).toList();
  }
}
