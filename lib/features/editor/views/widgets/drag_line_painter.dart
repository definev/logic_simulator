import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:logic_simulator/features/editor/views/entity/dot_drag_position.dart';
import 'package:logic_simulator/utils/vector.dart';
import 'package:vector_math/vector_math.dart' as vector_math;

class DragLinePainter extends CustomPainter {
  DragLinePainter({
    required this.enabled,
    required this.position,
    required this.color,
    super.repaint,
  });

  final DotDragPosition position;
  final bool enabled;
  final Color color;

  void _drawFrom(Path path, vector_math.Vector2 begin, vector_math.Vector2 end) {
    path.moveTo(begin.x, begin.y);
    final distance = begin.distanceTo(end) / 2;
    final dotMagnitudeVec = begin + vector_math.Vector2(distance, 0);
    final dragMagnitudeVec = end + vector_math.Vector2(-distance, 0);
    path.cubicTo(dotMagnitudeVec.x, dotMagnitudeVec.y, dragMagnitudeVec.x, dragMagnitudeVec.y, end.x, end.y);
    path = ArrowPath.addTip(path, isAdjusted: true, tipLength: 0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final DotDragPosition(:dot, :drag) = position;
    final dotVec = VectorUtils.fromOffset(dot);
    final dragVec = VectorUtils.fromOffset(drag);

    final Paint paint = Paint()
      ..color = switch (enabled) {
        true => color,
        false => color.withOpacity(0.4),
      }
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..strokeWidth = 5.0;

    var path = Path();
    if (dotVec.x < dragVec.x) {
      _drawFrom(path, dotVec, dragVec);
    } else {
      _drawFrom(path, dragVec, dotVec);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DragLinePainter oldDelegate) {
    return oldDelegate.position != position;
  }
}

class DragLinePaint extends StatelessWidget {
  const DragLinePaint({
    super.key,
    required this.position,
    required this.enabled,
    this.child,
  });

  final DotDragPosition position;
  final bool enabled;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomPaint(
      foregroundPainter: DragLinePainter(
        position: position,
        enabled: enabled,
        color: theme.colorScheme.secondary,
      ),
      child: child,
    );
  }
}
