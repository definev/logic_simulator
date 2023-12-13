import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logic_simulator/features/canvas/domain/canvas_element.dart';
import 'package:logic_simulator/features/canvas/views/binary_ilist.dart';
import 'package:logic_simulator/features/canvas/views/canvas_scroll_view.dart';

import 'canvas_two_dimensional_child_delegate.dart';

class CanvasView extends HookWidget {
  const CanvasView({super.key});

  static final rand = Random();

  @override
  Widget build(BuildContext context) {
    final binaryElementsList = useState([
      for (var column = 0; column < 5; column += 1)
        for (var row = 0; row < 5; row += 1)
          () {
            final offset = Offset(rand.nextDouble() * 1000 - 100, rand.nextDouble() * 2000 - 500);
            return CanvasElement(
              id: column * 5 + row,
              offset: offset,
            );
          }(),
    ].binaryList(CanvasTwoDimensionalChildDelegate.defaultCompare(Axis.horizontal)));

    return Material(
      color: Colors.red,
      child: Transform.scale(
        scale: 0.7,
        child: DecoratedBox(
          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          child: CanvasScrollView(
            clipBehavior: Clip.none,
            diagonalDragBehavior: DiagonalDragBehavior.free,
            delegate: CanvasTwoDimensionalChildDelegate(
              builder: (context, CanvasElement element) {
                return MovableCanvasElement(
                  element: element,
                  elements: binaryElementsList,
                  snap: false,
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${element.id}'),
                      ),
                    ),
                  ),
                );
              },
              elements: binaryElementsList.value,
            ),
            mainAxis: Axis.vertical,
          ),
        ),
      ),
    );
  }
}

class MovableCanvasElement extends HookWidget {
  const MovableCanvasElement({
    super.key,
    required this.element,
    required this.elements,
    required this.child,
    this.snap = false,
  });

  final CanvasElement element;
  final ValueNotifier<BinaryIList<CanvasElement>> elements;
  final bool snap;
  final Widget child;

  ValueChanged<Offset> get onCanvasElementMove => (offset) => elements.value = elements.value.lockAt(
        element,
        (element) => element.copyWith(offset: offset, isSelected: true),
      );
  VoidCallback get onCanvasElementMoveEnd => () => elements.value = elements.value.unlockAt(
        element,
        (element) => element.copyWith(isSelected: false),
      );

  @override
  Widget build(BuildContext context) {
    final lastOffset = useRef<Offset?>(null);
    final startPosition = useRef<Offset?>(null);

    return Listener(
      onPointerDown: (details) {
        lastOffset.value = element.offset;
        startPosition.value = details.localPosition;
      },
      onPointerMove: (details) {
        if (lastOffset.value == null) return;
        if (startPosition.value == null) return;

        final endPosition = details.localPosition;
        var delta = endPosition - startPosition.value!;
        var newOffset = lastOffset.value! + delta;
        if (snap) {
          newOffset = Offset(
            newOffset.dx - newOffset.dx % 100,
            newOffset.dy - newOffset.dy % 100,
          );
        }
        onCanvasElementMove(newOffset);
      },
      onPointerCancel: (_) => onCanvasElementMoveEnd(),
      onPointerUp: (details) {
        lastOffset.value = null;
        startPosition.value = null;
        onCanvasElementMoveEnd();
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
