import 'dart:math';

import 'package:material_theme_test/domain/game_object.dart';

class Tree extends GameObject {
  Tree({
    bool randomizeHeight = false,
    int randomizingMaxPercent = 30,
    double height = 1,
    double? posX,
    double? posY,
  }) : _height = height + _randomizeHeightChange(randomizingMaxPercent, height) {
    pos.set(x: posX, y: posY);
  }

  static double _randomizeHeightChange(
      int randomizingMaxPercent, double height) {
    double change =
    (Random().nextInt(randomizingMaxPercent * 2) - randomizingMaxPercent)
        .toDouble();
    return height * change;
  }

  final double _height;

  double get height => _height;
}
