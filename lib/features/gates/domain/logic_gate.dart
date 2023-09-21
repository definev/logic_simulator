// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logic_simulator/features/gates/domain/custom_gate.dart';

import 'logic_data.dart';

part 'logic_gate.g.dart';

class LogicException implements Exception {
  const LogicException._(this.message);

  factory LogicException.invalidLength(
    int length,
    int expected, {
    required String gate,
  }) =>
      LogicException._('$gate. invalid length: $length, expected: $expected');

  final String message;

  @override
  String toString() => message;
}

enum LogicGateType {
  and,
  or,
  nor,
  not,
  xor,
  nand,
  custom,
}

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

abstract class LogicGate extends ChangeNotifier {
  LogicGate({
    required LogicGateType type,
    required LogicData input,
    required LogicData output,
  })  : _type = type,
        _input = input,
        _output = output;

  static List<LogicGate> builtInGates = [
    ANDGate(),
    ORGate(),
    NORGate(),
    NOTGate(),
    XORGate(),
    NANDGate(),
  ];

  // ignore: prefer_final_fields
  LogicGateType _type;
  LogicGateType get type => _type;
  set type(LogicGateType data) {
    _type = data;
  }

  String get name;
  LogicData _input;
  @LogicDataConverter()
  LogicData get input => _input;
  set input(LogicData data) {
    _input = data;
    _output = compute();
    notifyListeners();
  }

  void silentUpdateInput(LogicData data) {
    _input = data;
    notifyListeners();
  }

  LogicData _output;
  @LogicDataConverter()
  LogicData get output => _output;
  set output(LogicData data) {
    _output = data;
    notifyListeners();
  }

  void silentUpdateOutput(LogicData data) {
    _output = data;
  }

  LogicData compute([LogicData? input]);

  LogicGate clone();
}

@JsonSerializable()
class ANDGate extends LogicGate {
  ANDGate._({
    required super.input,
    required super.output,
  }) : super(type: LogicGateType.and);

  factory ANDGate({bool strict = true}) {
    return ANDGate._(
      input: LogicData.fromBits(const [false, false]),
      output: LogicData.fromBits(const [false]),
    );
  }

  factory ANDGate.fromJson(Map<String, dynamic> json) => _$ANDGateFromJson(json);
  Map<String, dynamic> toJson() => _$ANDGateToJson(this);

  @override
  String get name => 'AND';

  @override
  LogicData compute([LogicData? input]) {
    input ??= this.input;
    return LogicData.bit(input.data.reduce((a, b) => a && b));
  }

  @override
  ANDGate clone() => ANDGate._(
        input: input,
        output: output,
      );
}

@JsonSerializable()
class ORGate extends LogicGate {
  ORGate._({
    required super.input,
    required super.output,
  }) : super(type: LogicGateType.or);

  factory ORGate({bool strict = true}) {
    return ORGate._(
      input: LogicData.fromBits(const [false, false]),
      output: LogicData.fromBits(const [false]),
    );
  }

  factory ORGate.fromJson(Map<String, dynamic> json) => _$ORGateFromJson(json);
  Map<String, dynamic> toJson() => _$ORGateToJson(this);

  @override
  String get name => 'OR';

  @override
  LogicData compute([LogicData? input]) {
    input ??= this.input;
    return LogicData.bit(input.data.reduce((a, b) => a || b));
  }

  @override
  LogicGate clone() => ORGate._(
        input: input,
        output: output,
      );
}

@JsonSerializable()
class NORGate extends LogicGate {
  NORGate._({
    required super.input,
    required super.output,
  }) : super(type: LogicGateType.nor);

  factory NORGate({bool strict = true}) {
    return NORGate._(
      input: LogicData.fromBits(const [false, false]),
      output: LogicData.fromBits(const [false]),
    );
  }

  factory NORGate.fromJson(Map<String, dynamic> json) => _$NORGateFromJson(json);
  Map<String, dynamic> toJson() => _$NORGateToJson(this);

  @override
  String get name => 'NOR';

  @override
  LogicData compute([LogicData? input]) {
    input ??= this.input;
    return LogicData.bit(!input.data.reduce((a, b) => a || b));
  }

  @override
  LogicGate clone() => NORGate._(
        input: input,
        output: output,
      );
}

@JsonSerializable()
class NOTGate extends LogicGate {
  NOTGate._({
    required super.input,
    required super.output,
  }) : super(type: LogicGateType.not);

  factory NOTGate({bool strict = true}) {
    return NOTGate._(
      input: LogicData.fromBits(const [false]),
      output: LogicData.fromBits(const [true]),
    );
  }

  factory NOTGate.fromJson(Map<String, dynamic> json) => _$NOTGateFromJson(json);
  Map<String, dynamic> toJson() => _$NOTGateToJson(this);

  @override
  String get name => 'NOT';

  @override
  LogicData compute([LogicData? input]) {
    input ??= this.input;
    return LogicData.bit(!input[0]);
  }

  @override
  LogicGate clone() => NOTGate._(
        input: input,
        output: output,
      );
}

@JsonSerializable()
class XORGate extends LogicGate {
  XORGate._({
    required super.input,
    required super.output,
  }) : super(type: LogicGateType.xor);

  factory XORGate({bool strict = true}) {
    return XORGate._(
      input: LogicData.fromBits(const [false, false]),
      output: LogicData.fromBits(const [false]),
    );
  }

  factory XORGate.fromJson(Map<String, dynamic> json) => _$XORGateFromJson(json);
  Map<String, dynamic> toJson() => _$XORGateToJson(this);

  @override
  String get name => 'XOR';

  @override
  LogicData compute([LogicData? input]) {
    input ??= this.input;
    return LogicData.bit(input.data.reduce((a, b) => a ^ b));
  }

  @override
  LogicGate clone() => XORGate._(
        input: input,
        output: output,
      );
}

@JsonSerializable()
class NANDGate extends LogicGate {
  NANDGate._({
    required super.input,
    required super.output,
  }) : super(type: LogicGateType.nand);

  factory NANDGate({bool strict = true}) {
    return NANDGate._(
      input: LogicData.fromBits(const [false, false]),
      output: LogicData.fromBits(const [false]),
    );
  }

  factory NANDGate.fromJson(Map<String, dynamic> json) => _$NANDGateFromJson(json);
  Map<String, dynamic> toJson() => _$NANDGateToJson(this);

  @override
  String get name => 'NAND';

  @override
  LogicData compute([LogicData? input]) {
    input ??= this.input;
    return LogicData.bit(!input.data.reduce((a, b) => a && b));
  }

  @override
  LogicGate clone() => NANDGate._(
        input: input,
        output: output,
      );
}
