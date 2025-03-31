import 'dart:math';

import 'package:flutter/material.dart';

class Background {
  final String filename;
  String get assetName => 'assets/backgrounds/$filename';
  final Color foregroundColor;

  const Background(this.filename, this.foregroundColor);
}

const _backgrounds = [
  Background('benaja-germann-1JRZN1K8cGo-unsplash.jpg', Colors.white),
  Background('benaja-germann-wKOX1F0wecc-unsplash.jpg', Colors.white),
  Background('colin-watts-O_vfjjh6t3k-unsplash.jpg', Colors.black),
  Background('darren-lawrence-Ad7-qVkGy7Y-unsplash.jpg', Colors.black),
  Background('gabriele-merlino-oiys4LLfO5M-unsplash.jpg', Colors.white),
  Background('ingmar-h--O8b5mIORMk-unsplash.jpg', Colors.white),
  Background('junel-mujar-51jzoz1dsro-unsplash.jpg', Colors.black),
  Background('marek-piwnicki-HxPkohFqDGY-unsplash.jpg', Colors.white),
  Background('pascal-debrunner-Bd-PwE6KnSc-unsplash.jpg', Colors.black),
  Background('steve-gribble-MUoP6i9w870-unsplash.jpg', Colors.white)
];

class BackgroundRandom {
  const BackgroundRandom._();

  static final _random = Random();

  static Background nextAsset() {
    final index = _random.nextInt(_backgrounds.length);
    return _backgrounds[index];
  }

  static List<Background> nextDistinctAssets(int count) {
    final indexes = <int>{};
    while (indexes.length < count) {
      indexes.add(_random.nextInt(_backgrounds.length));
    }
    return indexes.map((index) => _backgrounds[index]).toList();
  }
}
