import 'dart:math';

class GridPosition {
  GridPosition(this.x, this.y);

  final int x;
  final int y;

  late final double distance = 1 - sqrt(pow(x, 2) + pow(y, 2)) / 10;

  @override
  String toString() {
    return '(x: $x, y: $y)';
  }
}
