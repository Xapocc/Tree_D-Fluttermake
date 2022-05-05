import 'dart:math';

abstract class MyFormulas {
  static double angleFromTwoPoints(
      double startX, double startY, double endX, double endY) {
    double deltaX = endX - startX;
    double deltaY = endY - startY;

    double tang = deltaX / deltaY;
    tang = atan(tang) * 180 / pi;

    if (tang != double.nan) {
      if (deltaX < 0) {
        if (deltaY < 0) {
          tang *= -1;
        }
        if (deltaY >= 0) {
          tang = -180 - tang;
        }
      }
      if (deltaX >= 0) {
        if (deltaY < 0) {
          tang *= -1;
        }
        if (deltaY >= 0) {
          tang = 180 - tang;
        }
      }
    }

    return tang;
  }
}
