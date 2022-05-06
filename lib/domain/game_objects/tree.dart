import 'dart:math';

import 'package:material_theme_test/domain/game_object.dart';

class Tree extends GameObject {
  Tree({
    bool randomizeHeight = false,
    bool randomizeWidth = false,
    int heightMaxRandomizingPercent = 30,
    int widthMaxRandomizingPercent = 40,
    double height = 8,
    double width = 2,
    double? posX,
    double? posY,
  })  : _height = height +
            _randomizeHeightChange(
              heightMaxRandomizingPercent,
              height,
            ),
        _width = width +
            _randomizeWidthChange(
              widthMaxRandomizingPercent,
              width,
            ) {
    pos.set(x: posX, y: posY);
  }

  static double _randomizeHeightChange(
      int randomizingMaxPercent, double height) {
    double change =
        (Random().nextInt(randomizingMaxPercent * 2) - randomizingMaxPercent)
            .toDouble();
    return height * change / 100;
  }

  static double _randomizeWidthChange(int randomizingMaxPercent, double width) {
    double change =
        (Random().nextInt(randomizingMaxPercent * 2) - randomizingMaxPercent)
            .toDouble();
    return width * change / 100;
  }

  final double _height;
  final double _width;

  double get height => _height;

  double get width => _width;
}
