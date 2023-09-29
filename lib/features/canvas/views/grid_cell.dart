import 'package:flutter/material.dart';
import 'package:logic_simulator/features/canvas/domain/grid_position.dart';

class GridCell extends StatelessWidget {
  const GridCell({super.key, required this.size, required this.position});

  final double size;
  final GridPosition position;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onAccept: (data) {},
      builder: (_, candidateData, rejectedData) {
        return SizedBox.square(
          dimension: size,
          child: DecoratedBox(
            key: ValueKey(position),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: candidateData.isNotEmpty ? Colors.amber : Colors.amber.shade100,
            ),
            child: Text(position.toString()),
          ),
        );
      },
    );
  }
}
