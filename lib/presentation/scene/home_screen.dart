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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildLandscape(),
          ..._buildTrees(screenHeight!, screenWidth!),
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
                child: _buildMap(screenHeight!),
              ),
            ),
          ),
          _buildCrosshair(),
          _buildJoystick(),
        ],
      ),
    );
  }

  Widget _buildLandscape() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlueAccent, Colors.blue]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: FractionallySizedBox(
              heightFactor: 0.5,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.lightGreen, Colors.green]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrosshair() {
    return const Center(
      child: Icon(Icons.add_sharp),
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

  List<Widget> _buildTrees(double _screenHeight, double _screenWidth) {
    GameProcess().rearrangeTrees();

    List<Widget> output = [];
    for (Tree tree in GameProcess().trees) {
      double height = 0;
      double width = 0;
      double left = 0;
      double bottom = 0;

      double angle = MyFormulas.angleFromTwoPoints(
        GameProcess().player.pos.x,
        GameProcess().player.pos.y,
        tree.pos.x,
        tree.pos.y,
      );

      if (angle > Values.fov * 0.6 || angle < -Values.fov * 0.6) continue;

      double distance = sqrt(
        pow(GameProcess().player.pos.x - tree.pos.x, 2) +
            pow(GameProcess().player.pos.y - tree.pos.y, 2),
      );

      double sizeScale = 1.0 / (distance + 1);

      width = tree.width *
          _screenWidth /
          Values.fov *
          Values.fovObjectViewBaseAngle *
          sizeScale;
      height = tree.height *
          _screenWidth /
          Values.fov *
          Values.fovObjectViewBaseAngle *
          sizeScale;

      left = _screenWidth / 2 + (angle * _screenWidth / Values.fov - width / 2);

      bottom = _screenHeight / 2 -
          Values.playerHeight *
              _screenWidth /
              Values.fov *
              Values.fovObjectViewBaseAngle *
              sizeScale;

      output.add(
        Positioned(
          left: left,
          bottom: bottom,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.transparent, width: 1.0),
            ),
            child: Image.asset(
              "assets/tree.png",
              fit: BoxFit.fill,
            ),
            width: width,
            height: height,
          ),
        ),
      );
    }

    return output;
  }

  Widget _buildMap(double _screenHeight) {
    return Stack(
      children: [
        ..._buildMapTrees(_screenHeight),
        _buildMapPlayer(_screenHeight),
      ],
    );
  }

  List<Widget> _buildMapTrees(double _screenHeight) {
    List<Widget> output = [];

    for (Tree tree in GameProcess().trees) {
      output.add(
        Positioned(
          left: _screenHeight / (Values.mapSizeX * 2) * tree.pos.x +
              _screenHeight / 2 -
              2.5,
          top: _screenHeight / (Values.mapSizeY * 2) * tree.pos.y +
              _screenHeight / 2 -
              2.5,
          child: Container(
            color: Colors.black,
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
          _screenHeight / 2 -
          2.5,
      top: _screenHeight / (Values.mapSizeY * 2) * GameProcess().player.pos.y +
          _screenHeight / 2 -
          2.5,
      child: Container(
        color: Colors.red,
        width: 5.0,
        height: 5.0,
      ),
    );
  }
}
