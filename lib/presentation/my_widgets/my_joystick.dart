import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_theme_test/domain/my_formulas.dart';

class MyJoystick extends StatefulWidget {
  const MyJoystick({Key? key, required this.size, required this.callback})
      : super(key: key);

  final double size;
  final Function(double delta, double angle) callback;

  @override
  State<StatefulWidget> createState() => _MyJoystickState();
}

class _MyJoystickState extends State<MyJoystick> {
  Offset position = Offset.infinite;

  @override
  Widget build(BuildContext context) {
    double joystickSize = widget.size * 0.5;
    double joystickStickSize = joystickSize * 0.35;

    if (position == Offset.infinite) {
      position = Offset(joystickSize * 0.5 - joystickStickSize * 0.5,
          joystickSize * 0.5 - joystickStickSize * 0.5);
    }

    return Stack(
      children: [
        _buildJoystickBase(context, joystickSize),
        _buildJoystickStick(context, joystickStickSize),
        Container(
          width: joystickSize,
          height: joystickSize,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: GestureDetector(
            onPanDown: (details) {
              setState(() {
                Offset newPosition = Offset(
                    (details.localPosition.dx), details.localPosition.dy);
                position = _clampOffset(
                        newPosition, joystickSize, joystickStickSize) -
                    Offset(joystickStickSize * 0.5, joystickStickSize * 0.5);
              });
              Map<String, double> output =
                  _getOutput(position, joystickSize, joystickStickSize);
              widget.callback(output["delta"] ?? 0, output["angle"] ?? 0);
            },
            onPanUpdate: (details) {
              setState(() {
                Offset newPosition = Offset(
                    (details.localPosition.dx), details.localPosition.dy);
                position = _clampOffset(
                        newPosition, joystickSize, joystickStickSize) -
                    Offset(joystickStickSize * 0.5, joystickStickSize * 0.5);
              });
              Map<String, double> output =
                  _getOutput(position, joystickSize, joystickStickSize);
              widget.callback(output["delta"] ?? 0, output["angle"] ?? 0);
            },
            onPanEnd: (_) {
              setState(() {
                position = Offset(joystickSize * 0.5 - joystickStickSize * 0.5,
                    joystickSize * 0.5 - joystickStickSize * 0.5);
              });
              Map<String, double> output =
                  _getOutput(position, joystickSize, joystickStickSize);
              widget.callback(output["delta"] ?? 0, output["angle"] ?? 0);
            },
            onTapUp: (_) {
              setState(() {
                position = Offset(joystickSize * 0.5 - joystickStickSize * 0.5,
                    joystickSize * 0.5 - joystickStickSize * 0.5);
              });
              Map<String, double> output =
                  _getOutput(position, joystickSize, joystickStickSize);
              widget.callback(output["delta"] ?? 0, output["angle"] ?? 0);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJoystickBase(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withAlpha(50),
            Colors.black.withAlpha(50),
            Colors.white.withAlpha(50),
          ],
          stops: const [0, 0.98, 0.98],
        ),
      ),
    );
  }

  Widget _buildJoystickStick(BuildContext context, double size) {
    return Positioned(
      top: position.dy,
      left: position.dx,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withAlpha(30),
              Colors.black.withAlpha(50),
              Colors.white.withAlpha(50),
            ],
            stops: const [0, 0.98, 0.98],
          ),
        ),
      ),
    );
  }

  Offset _clampOffset(
      Offset initialOffset, double joystickBaseSize, double joystickStickSize) {
    // moving the start of the coordinate plane to the center of joystick
    Offset centeredOffset =
        initialOffset - Offset(joystickBaseSize * 0.5, joystickBaseSize * 0.5);

    double allowedRadius = joystickBaseSize * 0.5 - (joystickStickSize * 0.5);
    // calculating the actual distance to the touch point
    double mainDiagonal =
        sqrt(pow(centeredOffset.dx, 2) + pow(centeredOffset.dy, 2));

    if (mainDiagonal <= allowedRadius) return initialOffset;

    double newX = centeredOffset.dx * allowedRadius / mainDiagonal;
    double newY = centeredOffset.dy * allowedRadius / mainDiagonal;
    // returning the coordinate plane start to top left corner
    newX += joystickBaseSize * 0.5;
    newY += joystickBaseSize * 0.5;

    return Offset(newX, newY);
  }

  Map<String, double> _getOutput(
      Offset initialOffset, double joystickBaseSize, double joystickStickSize) {
    // moving the start of the coordinate plane to the center of joystick
    Offset centeredOffset = initialOffset -
        Offset(joystickBaseSize * 0.5 - joystickStickSize * 0.5,
            joystickBaseSize * 0.5 - joystickStickSize * 0.5);

    double allowedRadius = joystickBaseSize * 0.5 - (joystickStickSize * 0.5);

    double mainDiagonal =
        sqrt(pow(centeredOffset.dx, 2) + pow(centeredOffset.dy, 2));

    double tang = MyFormulas.angleFromTwoPoints(
      0,
      0,
      centeredOffset.dx,
      centeredOffset.dy,
    );

    return {"delta": mainDiagonal / allowedRadius, "angle": tang};
  }
}
