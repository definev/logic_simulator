import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logic_simulator/features/canvas/domain/grid_canvas.dart';
import 'package:logic_simulator/features/canvas/domain/grid_position.dart';
import 'package:logic_simulator/features/canvas/views/grid_cell.dart';
import 'package:supercharged/supercharged.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  bool firstBuild = true;
  late final TransformationController _controller;
  Quad? _viewport;
  set viewport(Quad? value) {
    if (value == null) return;
    _viewport = value;
  }

  double viewportThreshold = 20;
  bool onInteraction = false;
  bool onUpdateQuad = false;

  GridCanvas canvas = GridCanvas(
    cellSize: GridCanvas.cellSizeDefault,
  );

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
    canvas.addListener(onGridViewportUpdated);
  }

  @override
  void dispose() {
    canvas.removeListener(onGridViewportUpdated);
    super.dispose();
  }

  void onGridViewportUpdated() {
    setState(() {});
  }

  Size size = Size.zero;
  double maxWidth = 0;
  double maxHeight = 0;
  void onInteractionUpdated() {
    if (onUpdateQuad) return;
    final scaledSize = size * _controller.value.getMaxScaleOnAxis();
    Quad? viewport = _viewport;
    if (viewport == null) return;
    final topLeft = Vector3(
      viewport.point0.x.floorToDouble(),
      viewport.point0.y.floorToDouble(),
      viewport.point0.z.floorToDouble(),
    );
    final bottomRight = Vector3(
      viewport.point2.x.roundToDouble(),
      viewport.point2.y.roundToDouble(),
      viewport.point2.z.roundToDouble(),
    );
    double moveX = 0;
    double moveY = 0;

    Alignment? alignment = switch ((topLeft, bottomRight)) {
      final p when p.$1.x <= viewportThreshold && p.$1.y <= viewportThreshold => () {
          moveX = -scaledSize.width;
          moveY = -scaledSize.height;

          return Alignment.topLeft;
        }(),
      final p when p.$1.x <= viewportThreshold && p.$2.y >= maxHeight - viewportThreshold => () {
          moveX = -scaledSize.width;
          moveY = scaledSize.height;
          return Alignment.bottomLeft;
        }(),
      final p when p.$2.x >= maxWidth - viewportThreshold && p.$1.y <= viewportThreshold => () {
          moveX = scaledSize.width;
          moveY = -scaledSize.height;
          return Alignment.topRight;
        }(),
      final p when p.$2.x >= maxWidth - viewportThreshold && p.$2.y >= maxHeight - viewportThreshold => () {
          moveX = scaledSize.width;
          moveY = scaledSize.height;
          return Alignment.bottomRight;
        }(),
      final p when p.$1.x <= viewportThreshold => () {
          moveX = -scaledSize.width;
          return Alignment.centerLeft;
        }(),
      final p when p.$2.x >= maxWidth - viewportThreshold => () {
          moveX = scaledSize.width;
          return Alignment.centerRight;
        }(),
      final p when p.$1.y <= viewportThreshold => () {
          moveY = -scaledSize.height;
          return Alignment.topCenter;
        }(),
      final p when p.$2.y >= maxHeight - viewportThreshold => () {
          moveY = scaledSize.height;
          return Alignment.bottomCenter;
        }(),
      _ => null,
    };
    if (alignment == null) return;
    onUpdateQuad = true;
    translateViewport(moveX, moveY);
    canvas.viewport = canvas.viewport.moveAlignment(alignment);
    Future.delayed(100.milliseconds, () => onUpdateQuad = false);
  }

  void onFirstBuild(Size size) {
    Timer.run(() {
      final offset = Offset(size.width, size.height);
      _controller.value = Matrix4.identity()
        ..translate(-offset.dx, -offset.dy)
        ..scale(1.0);
    });
    firstBuild = false;
  }

  void translateViewport(double x, double y) {
    _controller.value = _controller.value..leftTranslate(x, y);
    setState(() {});
  }

  bool _isVisible(int row, int col) {
    if (_viewport == null) return false;
    final topLeft = Vector2(
      _viewport!.point0.x.floorToDouble(),
      _viewport!.point0.y.floorToDouble(),
    );
    final bottomRight = Vector2(
      _viewport!.point2.x.roundToDouble(),
      _viewport!.point2.y.roundToDouble(),
    );
    final topLeftCoor = _getAt(row + 1, col + 1);
    final bottomRightCoor = _getAt(row, col);
    if (topLeftCoor.x < topLeft.x || bottomRightCoor.x > bottomRight.x) return false;
    if (topLeftCoor.y < topLeft.y || bottomRightCoor.y > bottomRight.y) return false;
    return true;
  }

  ({int top, int bottom, int left, int right}) _getCornerBounds() {
    final viewport = _viewport!;
    int left = viewport.point0.x.floorToDouble() ~/ canvas.cellSize;
    int right = viewport.point2.x.roundToDouble() ~/ canvas.cellSize;
    int top = viewport.point0.y.floorToDouble() ~/ canvas.cellSize;
    int bottom = viewport.point2.y.roundToDouble() ~/ canvas.cellSize;
    return (top: top, bottom: bottom, left: left, right: right);
  }

  ({double x, double y}) _getAt(int row, int col) {
    return (x: row * canvas.cellSize, y: col * canvas.cellSize);
  }

  GridPosition _getCoorAt(int row, int col) {
    return GridPosition(row + canvas.viewport.origin.x - canvas.width, col + canvas.viewport.origin.y - canvas.height);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  size = canvas.fromSize(constraints.biggest);
                  maxWidth = 3 * size.width;
                  maxHeight = 3 * size.height;

                  if (firstBuild) onFirstBuild(size);

                  return InteractiveViewer.builder(
                    transformationController: _controller,
                    maxScale: 3.0,
                    minScale: 0.7,
                    onInteractionStart: (_) => onInteractionUpdated(),
                    onInteractionEnd: (_) => onInteractionUpdated(),
                    clipBehavior: Clip.none,
                    builder: (context, quad) {
                      viewport = quad;
                      return Container(
                        height: maxHeight,
                        width: maxWidth,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            if (_getCornerBounds() case final bounds) ...[
                              for (int row = bounds.left; row <= bounds.right; row++)
                                for (int col = bounds.top; col <= bounds.bottom; col++)
                                  Positioned(
                                    left: row * canvas.cellSize,
                                    top: col * canvas.cellSize,
                                    child: GridCell(
                                      size: canvas.cellSize,
                                      position: _getCoorAt(row, col),
                                    ),
                                  ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: NavigationBar(
                destinations: const [
                  NavigationDestination(
                    icon: Draggable(
                      feedback: SizedBox.square(
                        dimension: 30,
                        child: ColoredBox(color: Colors.red),
                      ),
                      child: Icon(Icons.abc),
                    ),
                    label: 'ABC',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.more),
                    label: 'More',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
