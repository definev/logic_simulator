import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:logic_simulator/features/canvas/domain/canvas_element.dart';
import 'package:logic_simulator/features/canvas/views/binary_ilist.dart';

class CanvasTwoDimensionalChildDelegate extends TwoDimensionalChildDelegate {
  CanvasTwoDimensionalChildDelegate({
    required this.elements,
    required this.builder,
    this.dimension = 100,
  });

  static Comparator<CanvasElement> defaultCompare(Axis axis) => switch (axis) {
        Axis.horizontal => (a, b) => a.offset.dx.compareTo(b.offset.dx),
        Axis.vertical => (a, b) => a.offset.dy.compareTo(b.offset.dy),
      };

  final BinaryIList<CanvasElement> elements;
  final Widget Function(BuildContext context, CanvasElement element) builder;
  final double dimension;

  Map<ChildVicinity, CanvasElement> _sortedElements = {};
  IList<(ChildVicinity, CanvasElement)> getVisibleElement(Offset topLeft, Offset bottomRight) {
    var sorted = elements.whereIndexed(
      (sorted) {
        final CanvasElement(:offset) = sorted;

        final deltaDxLeft = offset.dx - topLeft.dx;
        final deltaDxRight = bottomRight.dx - offset.dx;

        if (deltaDxLeft < 0) return -1;
        if (deltaDxRight < 0) return 1;
        return 0;
      },
    );
    if (sorted == null) return <(ChildVicinity, CanvasElement)>[].lock;
    sorted = sorted //
        .binaryIList(defaultCompare(Axis.vertical))
        .whereIndexed(
      (sorted) {
        final CanvasElement(:offset) = sorted;

        final deltaDyLeft = offset.dy - topLeft.dy;
        final deltaDyRight = bottomRight.dy - offset.dy;

        if (deltaDyLeft < 0) return -1;
        if (deltaDyRight < 0) return 1;
        return 0;
      },
    );
    if (sorted == null) return <(ChildVicinity, CanvasElement)>[].lock;
    _sortedElements = <ChildVicinity, CanvasElement>{};
    var list = sorted.list.map(_toVicinity).toIList();
    for (final selected in sorted.selectedSet) {
      if (_sortedElements[selected.vicinity] == null) {
        list = list.add(_toVicinity(selected));
      }
    }
    return list;
  }

  (ChildVicinity, CanvasElement) _toVicinity(o) {
    final copyVicinity = o.vicinity;
    _sortedElements[copyVicinity] = o;
    return (copyVicinity, o);
  }

  @override
  Widget? build(BuildContext context, ChildVicinity vicinity) {
    if (vicinity == ChildVicinity(xIndex: -1, yIndex: 0)) {
      return SizedBox.square();
    }
    if (vicinity.yIndex == 1) {
      return VerticalDivider(color: Colors.black, width: 1);
    }
    if (vicinity.yIndex == 2) {
      return Divider(height: 1);
    }

    if (_sortedElements[vicinity] case final element?) {
      return AutomaticKeepAlive(
        child: builder(context, element),
      );
    }
    return null;
  }

  @override
  bool shouldRebuild(covariant CanvasTwoDimensionalChildDelegate oldDelegate) => true;
}

typedef DistanceFunction<T> = int Function(T object);
