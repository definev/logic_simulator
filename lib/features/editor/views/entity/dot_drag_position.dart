import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';

part 'dot_drag_position.g.dart';

@CopyWith()
class DotDragPosition {
  final Offset dot;
  final Offset drag;

  const DotDragPosition({
    required this.dot,
    required this.drag,
  });
}
