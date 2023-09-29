import 'package:flutter/material.dart';

import 'grid_viewport.dart';

class GridCanvas extends ChangeNotifier {
  GridCanvas({
    required this.cellSize,
    GridViewport? viewport,
  }) : _viewport = viewport ?? GridViewport(origin: (x: 0, y: 0));

  final double cellSize;

  static double get cellSizeDefault => 200;

  GridViewport _viewport;
  GridViewport get viewport => _viewport;

  int height = 0;
  int width = 0;

  set viewport(GridViewport value) {
    _viewport = value;
    notifyListeners();
  }

  Size fromSize(Size biggest) {
    width = biggest.width ~/ cellSize + 1;
    height = biggest.height ~/ cellSize + 1;
    return Size(width * cellSize, height * cellSize);
  }
}
