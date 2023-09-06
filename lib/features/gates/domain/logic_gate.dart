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

abstract class LogicGate {
  const LogicGate({this.strict = true});
  final bool strict;

  @protected
  void onValidate(LogicData input) {
    if (strict) {
      if (validate(input) case final exception?) {
        throw exception;
      }
    }
  }

  LogicData compute(LogicData input);
  LogicException? validate(LogicData input);
}

class AndGate extends LogicGate {
  const AndGate({super.strict = true});

  @override
  LogicData compute(LogicData input) {
    onValidate(input);
    return LogicData.bit(input.data.reduce((a, b) => a && b));
  }

  @override
  LogicException? validate(LogicData input) {
    if (input.length < 2) {
      return LogicException.invalidLength(input.length, 2, gate: 'AndGate');
    }
    return null;
  }
}

class OrGate extends LogicGate {
  const OrGate({super.strict = true});

  @override
  LogicData compute(LogicData input) {
    return LogicData.bit(input.data.reduce((a, b) => a || b));
  }

  @override
  LogicException? validate(LogicData input) {
    if (input.length < 2) {
      return LogicException.invalidLength(input.length, 2, gate: 'OrGate');
    }
    return null;
  }
}

class NotGate extends LogicGate {
  const NotGate({super.strict = true});

  @override
  LogicData compute(LogicData input) {
    return LogicData.bit(!input[0]);
  }

  @override
  LogicException? validate(LogicData input) {
    if (input.length != 1) {
      return LogicException.invalidLength(input.length, 1, gate: 'NotGate');
    }
    return null;
  }
}

class BufferGate extends LogicGate {
  const BufferGate({super.strict = true});

  @override
  LogicData compute(LogicData input) {
    return LogicData.bit(input[0]);
  }

  @override
  LogicException? validate(LogicData input) {
    if (input.length != 1) {
      return LogicException.invalidLength(input.length, 1, gate: 'BufferGate');
    }
    return null;
  }
}
