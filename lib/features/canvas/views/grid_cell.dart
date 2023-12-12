import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logic_simulator/features/canvas/domain/grid_position.dart';

class GridCell extends StatelessWidget {
  const GridCell({super.key, required this.size, required this.position});

  final double size;
  final GridPosition position;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onAcceptWithDetails: (data) {},
      builder: (_, candidateData, rejectedData) => SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          key: ValueKey(position),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Color.lerp(Colors.amber, Colors.white, clampDouble(position.distance, 0, 1)),
          ),
          child: Material(
            color: Colors.transparent,
            child: Text(position.toString()),
          ),
        ),
      ),
    );
  }
}
