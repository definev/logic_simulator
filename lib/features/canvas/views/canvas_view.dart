import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logic_simulator/features/canvas/views/canvas_scroll_view.dart';

import 'canvas_two_dimensional_child_delegate.dart';

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  List<CanvasElement> elements = [];

  @override
  void initState() {
    super.initState();
    final rand = Random();
    elements = [
      for (var column = 0; column < 5; column += 1)
        for (var row = 0; row < 5; row += 1)
          () {
            final offset = Offset(rand.nextDouble() * 1000 - 100, rand.nextDouble() * 2000 - 500);
            return CanvasElement(offset: offset);
          }(),
    ];
    for (final (index, element) in elements.indexed) {
      print('index: $index, offset: ${element.offset}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.7,
      child: DecoratedBox(
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: CanvasScrollView(
          diagonalDragBehavior: DiagonalDragBehavior.free,
          delegate: CanvasTwoDimensionalChildDelegate(
            builder: (context, index, element) {
              return Material(
                color: Colors.transparent,
                child: FilledButton(
                  onPressed: () {},
                  child: Text('index: $index, offset: ${element.offset}'),
                ),
              );
            },
            elements: elements,
          ),
          clipBehavior: Clip.none,
        ),
      ),
    );
  }
}
