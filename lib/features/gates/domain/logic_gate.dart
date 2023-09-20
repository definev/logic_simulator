import 'package:flutter/material.dart';

import 'logic_data.dart';

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

abstract class LogicGate extends ChangeNotifier {
  LogicGate({
    required LogicData input,
    required LogicData output,
  })  : _input = input,
        _output = output;

  static List<LogicGate> builtInGates = [
    ANDGate(),
    ORGate(),
    NORGate(),
    NOTGate(),
    XORGate(),
    NANDGate(),
  ];

  String get name;
  LogicData _input;
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
  set output(LogicData data) {
    _output = data;
    notifyListeners();
  }

  LogicData get output => _output;

  void silentUpdateOutput(LogicData data) {
    _output = data;
  }

  LogicData compute([LogicData? input]);

  LogicGate clone();
}

class ANDGate extends LogicGate {
  ANDGate._({
    required super.input,
    required super.output,
  });

  factory ANDGate({bool strict = true}) {
    return ANDGate._(
      input: LogicData.fromBits(const [false, false]),
      output: LogicData.fromBits(const [false]),
    );
  }

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

class ORGate extends LogicGate {
  ORGate._({
    required super.input,
    required super.output,
  });

  factory ORGate({bool strict = true}) {
    return ORGate._(
      input: LogicData.fromBits(const [false, false]),
      output: LogicData.fromBits(const [false]),
    );
  }

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

class NORGate extends LogicGate {
  NORGate._({
    required super.input,
    required super.output,
  });

  factory NORGate({bool strict = true}) {
    return NORGate._(
      input: LogicData.fromBits(const [false, false]),
      output: LogicData.fromBits(const [false]),
    );
  }

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

class NOTGate extends LogicGate {
  NOTGate._({
    required super.input,
    required super.output,
  });

  factory NOTGate({bool strict = true}) {
    return NOTGate._(
      input: LogicData.fromBits(const [false]),
      output: LogicData.fromBits(const [true]),
    );
  }

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

class XORGate extends LogicGate {
  XORGate._({
    required super.input,
    required super.output,
  });

  factory XORGate({bool strict = true}) {
    return XORGate._(
      input: LogicData.fromBits(const [false, false]),
      output: LogicData.fromBits(const [false]),
    );
  }

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

class NANDGate extends LogicGate {
  NANDGate._({
    required super.input,
    required super.output,
  });

  factory NANDGate({bool strict = true}) {
    return NANDGate._(
      input: LogicData.fromBits(const [false, false]),
      output: LogicData.fromBits(const [false]),
    );
  }

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
