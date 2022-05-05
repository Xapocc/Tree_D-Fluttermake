import 'dart:math';

import 'package:material_theme_test/domain/game_objects/player.dart';
import 'package:material_theme_test/domain/game_objects/tree.dart';
import 'package:material_theme_test/misc/values.dart';

class GameProcess {
  static final GameProcess _singleton = GameProcess._constructor();

  factory GameProcess() {
    return _singleton;
  }

  GameProcess._constructor() {
    for (int i = 0; i < Values.treesNumber; i++) {
      trees.add(Tree(
        posX: 0,
        posY: -50,
      ));

      /*trees.add(
        Tree(
          randomizeHeight: true,
          posX: (Random().nextInt(Values.mapSizeX * 2) - Values.mapSizeX)
              .toDouble(),
          posY: (Random().nextInt(Values.mapSizeY * 2) - Values.mapSizeY)
              .toDouble(),
        ),
      );*/
    }
  }

  final Player player = Player();

  final List<Tree> trees = [];
}
