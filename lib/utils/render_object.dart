import 'package:flutter/material.dart';

class RenderObjectUtils {
  static Offset getOrigin(BuildContext context, [BuildContext? parent]) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  static Offset getCenter(BuildContext context, [BuildContext? parent]) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final globalPoint = renderBox.localToGlobal(renderBox.size.center(Offset.zero));
    if (parent == null) return globalPoint;
    final RenderBox parentRenderBox = parent.findRenderObject() as RenderBox;
    final localPoint = parentRenderBox.globalToLocal(globalPoint);
    return localPoint;
  }

  static Size getSize(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  static Offset transformLocalToGlobal(BuildContext context, Offset point) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(point);
  }

  static Offset transformGlobalToLocal(BuildContext context, Offset point) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.globalToLocal(point);
  }
}
