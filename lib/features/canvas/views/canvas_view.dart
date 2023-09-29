import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logic_simulator/features/canvas/domain/grid_canvas.dart';
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
    if (_viewport == value) return;
    _viewport = value;
    Timer.run(() => setState(() {}));
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
                    builder: (context, quad) {
                      viewport = quad;
                      return Container(
                        height: maxHeight,
                        width: maxWidth,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            for (int i = 0; i < 3; i++)
                              for (int j = 0; j < 3; j++)
                                () {
                                  final coor =
                                      (x: i + canvas.viewport.origin.x - 1, y: j + canvas.viewport.origin.y - 1);
                                  final color = Colors.blue.withOpacity(
                                    (1 -
                                            (Vector2.all(0.0)
                                                    .distanceTo(Vector2(coor.x.toDouble(), coor.y.toDouble())) /
                                                10))
                                        .clamp(0, 1),
                                  );
                                  return Positioned(
                                    left: i * size.width,
                                    top: j * size.height,
                                    child: Container(
                                      height: size.height,
                                      width: size.width,
                                      color: color,
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text('(${coor.x}, ${coor.y})'),
                                      ),
                                    ),
                                  );
                                }(),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (_viewport case final viewport?)
              Align(
                alignment: Alignment.bottomRight,
                child: ColoredBox(
                  color: Colors.blue,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Topleft: (${viewport.point0.x.floorToDouble()}, ${viewport.point0.y.floorToDouble()})',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Bottomright: (${viewport.point2.x.roundToDouble()}, ${viewport.point2.y.roundToDouble()})',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
