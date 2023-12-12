import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:logic_simulator/features/canvas/views/binary_ilist.dart';

class CanvasElement extends Equatable {
  const CanvasElement({required this.offset});

  final Offset offset;

  @override
  List<Object?> get props => [offset];
}

class CanvasTwoDimensionalChildDelegate extends TwoDimensionalChildDelegate {
  CanvasTwoDimensionalChildDelegate({
    required this.elements,
    required this.builder,
  });

  final List<CanvasElement> elements;
  late final BinaryIList<(int, CanvasElement)> _sortedDx = IList(elements.indexed) //
      .binaryIList(defaultCompare(Axis.horizontal));

  static Comparator<(int, CanvasElement)> defaultCompare(Axis axis) => switch (axis) {
        Axis.horizontal => (a, b) => a.$2.offset.dx.compareTo(b.$2.offset.dx),
        Axis.vertical => (a, b) => a.$2.offset.dy.compareTo(b.$2.offset.dy),
      };

  final Widget Function(BuildContext context, int index, CanvasElement element) builder;

  late Map<ChildVicinity, (int, CanvasElement)> _sortedElements = {};
  IList<(ChildVicinity, CanvasElement)> getVisibleElement(Offset topLeft, Offset bottomRight) {
    var sorted = _sortedDx.whereIndexed(
      (sorted) {
        final (_, CanvasElement(:offset)) = sorted;

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
        final (_, CanvasElement(:offset)) = sorted;

        final deltaDyLeft = offset.dy - topLeft.dy;
        final deltaDyRight = bottomRight.dy - offset.dy;

        if (deltaDyLeft < 0) return -1;
        if (deltaDyRight < 0) return 1;
        return 0;
      },
    );
    if (sorted == null) return <(ChildVicinity, CanvasElement)>[].lock;
    _sortedElements = <ChildVicinity, (int, CanvasElement)>{};
    return sorted.list.map(
      (o) {
        final copyVicinity = ChildVicinity(xIndex: o.$1, yIndex: 0);
        _sortedElements[copyVicinity] = o;
        return (copyVicinity, o.$2);
      },
    ).toIList();
  }

  @override
  Widget? build(BuildContext context, ChildVicinity vicinity) {
    if (vicinity == ChildVicinity(xIndex: -1, yIndex: 0)) {
      return SizedBox.square(
        dimension: 100,
        child: ColoredBox(
          color: Colors.red,
        ),
      );
    }
    if (_sortedElements[vicinity] case final element?) {
      return AutomaticKeepAlive(
        child: builder(context, element.$1, element.$2),
      );
    }
    return null;
  }

  @override
  bool shouldRebuild(covariant CanvasTwoDimensionalChildDelegate oldDelegate) => elements != oldDelegate.elements;
}

extension on ChildVicinity {
  ChildVicinity get copy => ChildVicinity(xIndex: xIndex, yIndex: yIndex);
}

typedef DistanceFunction<T> = int Function(T object);
