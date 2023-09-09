// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:logic_simulator/features/gates/domain/logic_data.dart';

import 'instruction.dart';
import 'logic_gate.dart';

typedef LogicDataLabelMap = Map<int, String>;

class CustomGate extends LogicGate {
  CustomGate({
    required this.gates,
    required this.instructions,
    required super.input,
    required super.output,
    LogicDataLabelMap? inputLabel,
    LogicDataLabelMap? outputLabel,
  })  : _inputLabel = inputLabel ?? {},
        _outputLabel = outputLabel ?? {} {
    gates.map((e) => e.addListener(notifyListeners));
  }

  final List<LogicGate> gates;
  final List<Instruction> instructions;
  LogicDataLabelMap _inputLabel;
  set inputLabel(LogicDataLabelMap value) => _inputLabel = value;
  LogicDataLabelMap get inputLabel => _inputLabel;

  LogicDataLabelMap _outputLabel;
  set outputLabel(LogicDataLabelMap value) => _outputLabel = value;
  LogicDataLabelMap get outputLabel => _outputLabel;

  @override
  void dispose() {
    gates.map((e) => e.removeListener(notifyListeners));
    super.dispose();
  }

  String _name = 'custom';
  @override
  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  void _setInstruction(LogicData input, LogicData output) {
    for (final instruction in instructions) {
      switch (instruction) {
        case SetInstruction(:final at, :final atIndex, :final to, :final toIndex):
          if (at == -1) {
            final toGate = gates[to];
            toGate.input[toIndex] = input[atIndex];
          } else if (to == -1) {
            final atGate = gates[at];
            output[atIndex] = atGate.output[atIndex];
          } else {
            final atGate = gates[at];
            final toGate = gates[to];
            toGate.input[toIndex] = atGate.output[atIndex];
          }
      }
    }
  }

  @override
  LogicData compute([LogicData? input]) {
    for (final gate in gates) {
      gate.output = gate.compute();
    }
    _setInstruction(input ?? this.input, output);
    return output;
  }
}
