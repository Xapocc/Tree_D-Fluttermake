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
      trees.add(
        Tree(
          randomizeHeight: true,
          randomizeWidth: true,
          height: 20,
          width: 8,
          posX: (Random().nextInt(Values.mapSizeX * 2) - Values.mapSizeX)
              .toDouble(),
          posY: (Random().nextInt(Values.mapSizeY * 2) - Values.mapSizeY)
              .toDouble(),
        ),
      );
    }
  }

  void rearrangeTrees() {
    trees.sort((tree0, tree1) {
      double distance0 = sqrt(
        pow(player.pos.x - tree0.pos.x, 2) + pow(player.pos.y - tree0.pos.y, 2),
      );

      double distance1 = sqrt(
        pow(player.pos.x - tree1.pos.x, 2) + pow(player.pos.y - tree1.pos.y, 2),
      );

      if (distance0 > distance1) return -1;
      if (distance0 < distance1) return 1;
      return 0;
    });
  }

  final Player player = Player();

  final List<Tree> trees = [];
}
