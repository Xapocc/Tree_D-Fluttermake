class GameObject {
  GameObject({double? posX, double? posY}) {
    _pos.set(x: posX, y: posY);
  }

  final Position _pos = Position();

  Position get pos => _pos;
}

class Position {
  Position({double? x, double? y})
      : _x = x ?? 0,
        _y = y ?? 0;

  double _x, _y;

  double get x => _x;

  double get y => _y;

  void set({double? x, double? y}) {
    _x = x ?? _x;
    _y = y ?? _y;
  }
}
