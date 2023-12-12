import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logic_simulator/features/canvas/views/canvas_scroll_view.dart';

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  late final CanvasTwoDimensionalChildDelegate delegate;

  @override
  void initState() {
    super.initState();
    final rand = Random();
    delegate = CanvasTwoDimensionalChildDelegate(
      [
        for (var column = 0; column < 5; column += 1)
          for (var row = 0; row < 5; row += 1)
            () {
              final randSize = Size(50 + rand.nextDouble() * 100, 50 + rand.nextDouble() * 100);
              return CanvasElement(
                ChildVicinity(xIndex: column, yIndex: row),
                size: randSize,
                child: Container(
                  height: randSize.height,
                  width: randSize.width,
                  color: Colors.amber.withOpacity(
                    (Offset(
                              column.toDouble(),
                              row.toDouble(),
                            ).distanceSquared /
                            100)
                        .clamp(0.5, 1),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Text('$column : $row'),
                  ),
                ),
                offset: Offset(rand.nextDouble() * 500, rand.nextDouble() * 800),
              );
            }(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CanvasScrollView(
      diagonalDragBehavior: DiagonalDragBehavior.none,
      delegate: delegate,
    );
  }
}
