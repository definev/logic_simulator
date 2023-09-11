import 'package:flutter/material.dart';

class RenderObjectUtils {
  static Offset getOrigin(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  static Offset getCenter(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(renderBox.size.center(Offset.zero));
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
