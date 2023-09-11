import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

class VectorUtils {
  static Vector2 fromOffset(Offset offset) {
    return Vector2(offset.dx, offset.dy);
  }
}
