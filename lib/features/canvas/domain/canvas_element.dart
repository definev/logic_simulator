import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'canvas_element.g.dart';

@CopyWith()
class CanvasElement extends Equatable {
  CanvasElement({
    required this.id,
    required this.offset,
    this.isSelected = false,
  });

  final int id;
  final Offset offset;
  final bool isSelected;

  late final ChildVicinity vicinity = ChildVicinity(xIndex: id, yIndex: 3);

  @override
  List<Object?> get props => [id];
}
