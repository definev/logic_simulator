// ignore_for_file: unused_element

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logic_simulator/features/gates/domain/logic_gate_type.dart';

import 'logic_data.dart';

part 'logic_gate.g.dart';

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
  // ignore: unnecessary_getters_setters
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

  void dumpLog() {
    log('name: $name');
    log('input: $input');
    log('output: $output');
  }
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
