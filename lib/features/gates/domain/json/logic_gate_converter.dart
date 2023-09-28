// ignore_for_file: unused_element

import 'package:json_annotation/json_annotation.dart';
import 'package:logic_simulator/features/gates/domain/custom_gate.dart';
import 'package:logic_simulator/features/gates/domain/logic_gate.dart';
import 'package:logic_simulator/features/gates/domain/logic_gate_type.dart';

class LogicGateConverter extends JsonConverter<LogicGate, Map<String, dynamic>> {
  const LogicGateConverter();

  @override
  LogicGate fromJson(Map<String, dynamic> json) {
    final type = LogicGateType.values.asNameMap()[json['type']]!;
    switch (type) {
      case LogicGateType.and:
        return ANDGate.fromJson(json);
      case LogicGateType.or:
        return ORGate.fromJson(json);
      case LogicGateType.nor:
        return NORGate.fromJson(json);
      case LogicGateType.not:
        return NOTGate.fromJson(json);
      case LogicGateType.xor:
        return XORGate.fromJson(json);
      case LogicGateType.nand:
        return NANDGate.fromJson(json);
      case LogicGateType.custom:
        return CustomGate.fromJson(json);
    }
  }

  @override
  Map<String, dynamic> toJson(LogicGate object) {
    return switch (object.type) {
      LogicGateType.and => (object as ANDGate).toJson(),
      LogicGateType.or => (object as ORGate).toJson(),
      LogicGateType.nor => (object as NORGate).toJson(),
      LogicGateType.not => (object as NOTGate).toJson(),
      LogicGateType.xor => (object as XORGate).toJson(),
      LogicGateType.nand => (object as NANDGate).toJson(),
      LogicGateType.custom => (object as CustomGate).toJson(),
    };
  }
}
