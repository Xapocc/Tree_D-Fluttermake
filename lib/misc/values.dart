abstract class Values {
  static const double speedMultiplier = 0.1;
  static const double playerHeight = 2;
  static const int treesNumber = 100;

  static const int mapSizeX = 100;
  static const int mapSizeY = 100;

  static const int fov = 90;

  // angle that is being covered by an object with width of 1m at 1m distance
  static const int fovObjectViewBaseAngle = fov ~/ 3;
}
