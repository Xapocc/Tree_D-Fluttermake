import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_theme_test/domain/game_objects/tree.dart';
import 'package:material_theme_test/domain/game_process.dart';
import 'package:material_theme_test/domain/my_formulas.dart';
import 'package:material_theme_test/misc/values.dart';
import 'package:material_theme_test/presentation/my_widgets/my_joystick.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const double speed = Values.speedMultiplier;

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  double? screenHeight, screenWidth;
  double currentDelta = 0, currentAngle = 0;
  late Ticker ticker;

  @override
  void initState() {
    super.initState();
    ticker = Ticker((duration) {
      setState(() {
        if (currentDelta == 0) return;

        double x = sin(currentAngle * pi / 180);
        double y = -cos(currentAngle * pi / 180);

        setState(() {
          double currentPosX = GameProcess().player.pos.x;
          double currentPosY = GameProcess().player.pos.y;
          GameProcess().player.pos.set(
                x: currentPosX + x * currentDelta * HomeScreen.speed,
                y: currentPosY + y * currentDelta * HomeScreen.speed,
              );
        });
      });
    });
    ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight ??= min<double>(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    screenWidth ??= max<double>(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ..._buildTrees(),
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 1.0,
                  ),
                ),
                child: Stack(
                  children: [
                    ..._buildMapTrees(screenHeight!),
                    _buildMapPlayer(screenHeight!),
                  ],
                ),
              ),
            ),
          ),
          _buildJoystick(),
        ],
      ),
    );
  }

  Widget _buildJoystick() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: MyJoystick(
          size: screenHeight ?? 0,
          callback: (delta, angle) {
            setState(
              () {
                currentDelta = delta;
                currentAngle = angle;
              },
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildMapTrees(double _screenHeight) {
    List<Widget> output = [];

    for (Tree tree in GameProcess().trees) {
      output.add(
        Positioned(
          left: _screenHeight / (Values.mapSizeX * 2) * tree.pos.x +
              _screenHeight / 2,
          top: _screenHeight / (Values.mapSizeY * 2) * tree.pos.y +
              _screenHeight / 2,
          child: Container(
            color: Colors.green,
            width: 5.0,
            height: 5.0,
          ),
        ),
      );
    }

    return output;
  }

  Widget _buildMapPlayer(double _screenHeight) {
    return Positioned(
      left: _screenHeight / (Values.mapSizeX * 2) * GameProcess().player.pos.x +
          _screenHeight / 2,
      top: _screenHeight / (Values.mapSizeY * 2) * GameProcess().player.pos.y +
          _screenHeight / 2,
      child: Container(
        color: Colors.red,
        width: 5.0,
        height: 5.0,
      ),
    );
  }

  List<Widget> _buildTrees() {
    List<Widget> output = [];
    for (Tree tree in GameProcess().trees) {
      double baseHeight = 100;

      double height = 50;
      double left = 0;
      double bottom = 50;

      double distance = sqrt(
        pow(GameProcess().player.pos.x - tree.pos.x, 2) +
            pow(GameProcess().player.pos.y - tree.pos.y, 2),
      );

      double angle = MyFormulas.angleFromTwoPoints(GameProcess().player.pos.x,
          GameProcess().player.pos.y, tree.pos.x, tree.pos.y);


      output.add(
        Positioned(
          left: left,
          bottom: bottom,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              border: Border.all(color: Colors.white, width: 1.0),
            ),
            width: height / 2,
            height: height,
          ),
        ),
      );
    }

    return output;
  }
}
