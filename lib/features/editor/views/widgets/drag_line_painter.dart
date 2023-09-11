import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:logic_simulator/features/editor/views/entity/dot_drag_position.dart';
import 'package:logic_simulator/utils/vector.dart';
import 'package:vector_math/vector_math.dart' as vector_math;

class DragLinePainter extends CustomPainter {
  DragLinePainter({super.repaint, required this.position});

  final DotDragPosition position;

  @override
  void paint(Canvas canvas, Size size) {
    final DotDragPosition(:dot, :drag) = position;
    final dotVec = VectorUtils.fromOffset(dot);
    final dragVec = VectorUtils.fromOffset(drag);

    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3.0;

    var path = Path();
    path.moveTo(dotVec.x, dotVec.y);
    final distance = dotVec.distanceTo(dragVec) / 2;
    final dotMagnitudeVec = dotVec + vector_math.Vector2(distance, 0);
    final dragMagnitudeVec = dragVec + vector_math.Vector2(-distance, 0);
    path.cubicTo(dotMagnitudeVec.x, dotMagnitudeVec.y, dragMagnitudeVec.x, dragMagnitudeVec.y, dragVec.x, dragVec.y);
    path = ArrowPath.addTip(path, isAdjusted: true, tipLength: 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DragLinePainter oldDelegate) {
    return oldDelegate.position != position;
  }
}

class DragLinePaint extends StatelessWidget {
  const DragLinePaint({super.key, required this.position, this.child});

  final DotDragPosition position;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: DragLinePainter(position: position),
      child: child,
    );
  }
}
