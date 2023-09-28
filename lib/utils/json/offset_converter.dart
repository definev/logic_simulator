
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

class OffsetConverter extends JsonConverter<Offset, List<dynamic>> {
  /// Serialize [Offset] to [List].
  const OffsetConverter();

  @override
  Offset fromJson(List<dynamic> json) {
    final dx = json[0] as double;
    final dy = json[1] as double;
    return Offset(dx, dy);
  }

  @override
  List<double> toJson(Offset object) => [object.dx, object.dy];
}