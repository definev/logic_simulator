import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef CanvasSize = ({Offset offset, Size size});

extension on CanvasSize {
  Offset get maxSize => offset + Offset(size.width, size.height);
}

class CanvasElement extends Equatable {
  const CanvasElement(
    this.vicinity, {
    required this.child,
    required this.size,
    required this.offset,
  });

  final ChildVicinity vicinity;
  final Size size;
  final Widget child;
  final Offset offset;

  @override
  List<Object?> get props => [vicinity.xIndex, vicinity.yIndex, offset];
}

class CanvasTwoDimensionalChildDelegate extends TwoDimensionalChildDelegate {
  CanvasTwoDimensionalChildDelegate(this.elements) {
    for (final element in elements) {
      _sortedElements[element.vicinity] = element;
    }
  }

  final List<CanvasElement> elements;
  late final Map<ChildVicinity, CanvasElement> _sortedElements = {};
  List<CanvasElement> getVisibleElement(Offset topLeft, Offset bottomRight) {
    final result = <CanvasElement>[];

    for (final element in elements) {
      final offset = element.offset;
      if (offset.dx > bottomRight.dx ||
          offset.dx < topLeft.dx ||
          offset.dy > bottomRight.dy ||
          offset.dy < topLeft.dy) {
        continue;
      }
      result.add(element);
    }

    return result;
  }

  late final CanvasSize _canvasSize = () {

    var max = Offset.zero;
    var offset = Offset.zero;
    var size = Size.zero;
    for (final element in elements) {

      if (max.dx < element.offset.dx + element.size.width) {
        max = Offset(element.offset.dx + element.size.width, max.dy);
        offset = Offset(element.offset.dx, offset.dy);
        size = Size(element.size.width, size.height);
      }
      if (max.dy < element.offset.dy + element.size.height) {
        max = Offset(max.dx, element.offset.dy + element.size.height);
        offset = Offset(offset.dx, element.offset.dy);
        size = Size(size.width, element.size.height);
      }
    }
    return (offset: offset, size: size);
  }();

  @override
  Widget? build(BuildContext context, ChildVicinity vicinity) {
    if (_sortedElements[vicinity] case final element?) {
      return AutomaticKeepAlive(child: element.child);
    }
    return null;
  }

  @override
  bool shouldRebuild(covariant CanvasTwoDimensionalChildDelegate oldDelegate) => elements != oldDelegate.elements;
}

class CanvasScrollView extends TwoDimensionalScrollView {
  const CanvasScrollView({
    super.key,
    required super.delegate,
    super.cacheExtent,
    super.clipBehavior,
    super.diagonalDragBehavior,
    super.verticalDetails = const ScrollableDetails.vertical(),
    super.horizontalDetails = const ScrollableDetails.horizontal(),
    super.dragStartBehavior = DragStartBehavior.start,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.mainAxis = Axis.vertical,
    super.primary,
  });

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return CanvasTwoDimensionalViewport(
      delegate: delegate,
      horizontalAxisDirection: horizontalDetails.direction,
      horizontalOffset: horizontalOffset,
      verticalAxisDirection: verticalDetails.direction,
      verticalOffset: verticalOffset,
      mainAxis: mainAxis,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }
}

class CanvasTwoDimensionalViewport extends TwoDimensionalViewport {
  const CanvasTwoDimensionalViewport({
    super.key,
    required super.delegate,
    required super.horizontalAxisDirection,
    required super.horizontalOffset,
    required super.verticalAxisDirection,
    required super.verticalOffset,
    required super.mainAxis,
    super.cacheExtent,
    super.clipBehavior,
  });

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    return CanvasRenderTwoDimensionalViewport(
      childManager: context as TwoDimensionalChildManager,
      delegate: delegate,
      horizontalAxisDirection: horizontalAxisDirection,
      horizontalOffset: horizontalOffset,
      mainAxis: mainAxis,
      verticalAxisDirection: verticalAxisDirection,
      verticalOffset: verticalOffset,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant CanvasRenderTwoDimensionalViewport renderObject,
  ) {
    renderObject
      ..delegate = delegate
      ..horizontalAxisDirection = horizontalAxisDirection
      ..horizontalOffset = horizontalOffset
      ..mainAxis = mainAxis
      ..verticalAxisDirection = verticalAxisDirection
      ..verticalOffset = verticalOffset;
  }
}

class CanvasRenderTwoDimensionalViewport extends RenderTwoDimensionalViewport {
  CanvasRenderTwoDimensionalViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.delegate,
    required super.mainAxis,
    required super.childManager,
    required super.cacheExtent,
    required super.clipBehavior,
  });

  @override
  void layoutChildSequence() {
    final horizontalPixels = horizontalOffset.pixels;
    final verticalPixels = verticalOffset.pixels;
    final viewportHeight = viewportDimension.height + cacheExtent;
    final viewportWidth = viewportDimension.width + cacheExtent;

    final canvasDelegate = delegate as CanvasTwoDimensionalChildDelegate;

    final elements = canvasDelegate.getVisibleElement(
      Offset(horizontalPixels, verticalPixels) - Offset(cacheExtent, cacheExtent),
      Offset(horizontalPixels + viewportWidth, verticalPixels + viewportHeight),
    );

    for (final element in elements) {
      if (buildOrObtainChildFor(element.vicinity) case final child?) {
        child.layout(constraints.loosen());
        parentDataOf(child).layoutOffset = element.offset - Offset(horizontalPixels, verticalPixels);
      }
    }

    final maxSize = canvasDelegate._canvasSize.maxSize;
    verticalOffset.applyContentDimensions(
      0.0,
      (maxSize.dy - viewportDimension.height).clamp(0, double.infinity),
    );
    horizontalOffset.applyContentDimensions(
      0.0,
      (maxSize.dx - viewportDimension.width).clamp(0, double.infinity),
    );
  }
}
