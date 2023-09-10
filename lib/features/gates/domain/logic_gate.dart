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

  String get name;
  LogicData _input;
  LogicData get input => _input;
  set input(LogicData data) {
    _input = data;
    _output = compute(data);
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

  LogicData compute([LogicData? input]);
}

class AndGate extends LogicGate {
  AndGate._({
    required super.input,
    required super.output,
  });

  factory AndGate({bool strict = true}) {
    return AndGate._(
      input: LogicData.fromBits([false, false]),
      output: LogicData.fromBits([false]),
    );
  }

  @override
  String get name => 'AND';

  @override
  LogicData compute([LogicData? input]) {
    input ??= this.input;
    return LogicData.bit(input.data.reduce((a, b) => a && b));
  }
}

class OrGate extends LogicGate {
  OrGate._({
    required super.input,
    required super.output,
  });

  factory OrGate({bool strict = true}) {
    return OrGate._(
      input: LogicData.fromBits([false, false]),
      output: LogicData.fromBits([false]),
    );
  }

  @override
  String get name => 'OR';

  @override
  LogicData compute([LogicData? input]) {
    input ??= this.input;
    return LogicData.bit(input.data.reduce((a, b) => a || b));
  }
}

class NotGate extends LogicGate {
  NotGate._({
    required super.input,
    required super.output,
  });

  factory NotGate({bool strict = true}) {
    return NotGate._(
      input: LogicData.fromBits([false]),
      output: LogicData.fromBits([true]),
    );
  }

  @override
  String get name => 'NOT';

  @override
  LogicData compute([LogicData? input]) {
    input ??= this.input;
    return LogicData.bit(!input[0]);
  }
}
