class GridPosition {
  const GridPosition(this.x, this.y);

  final int x;
  final int y;

  @override
  String toString() {
    return '(x: $x, y: $y)';
  }
}
