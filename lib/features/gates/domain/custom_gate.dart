// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:logic_simulator/features/gates/domain/logic_data.dart';

import 'instruction.dart';
import 'logic_gate.dart';

typedef LogicDataLabelMap = Map<int, String>;

class CustomGate extends LogicGate {
  CustomGate({
    required this.gates,
    List<Instruction> instructions = const [],
    required super.input,
    required super.output,
    LogicDataLabelMap? inputLabel,
    LogicDataLabelMap? outputLabel,
  })  : _inputLabel = inputLabel ?? {},
        _outputLabel = outputLabel ?? {} {
    gates.map((e) => e.addListener(notifyListeners));
    this.instructions = instructions;
  }

  final List<LogicGate> gates;

  late List<AddressInstruction> _inputInstructions;
  late List<AddressInstruction> _outputInstructions;
  set instructions(List<Instruction> value) {
    _inputInstructions = value.fold([], (value, element) {
      if (element is AddressInstruction) value.add(element);
      return value;
    });
    _outputInstructions = value.fold([], (value, element) {
      if (element is AddressInstruction && element.isOutput) value.add(element);
      return value;
    });
  }

  void addInputInstruction(AddressInstruction instruction) {
    _inputInstructions.removeWhere((inst) => inst.to == instruction.to);
    _inputInstructions.add(instruction);
    compute();
  }

  void addOutputInstruction(AddressInstruction instruction) {
    _outputInstructions.removeWhere((inst) => inst.toIndex == instruction.toIndex);
    _outputInstructions.add(instruction);
  }

  LogicDataLabelMap _inputLabel;
  set inputLabel(LogicDataLabelMap value) {
    _inputLabel = value;
    notifyListeners();
  }

  LogicDataLabelMap get inputLabel => _inputLabel;

  LogicDataLabelMap _outputLabel;
  set outputLabel(LogicDataLabelMap value) {
    _outputLabel = value;
    notifyListeners();
  }

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

  @override
  LogicData compute([LogicData? input]) {
    _executeInputInstruction(input ?? this.input);
    for (final gate in gates) {
      gate.output = gate.compute();
    }
    _executeOutputInstruction(input ?? this.input);
    return output;
  }

  void _executeInputInstruction(LogicData input) {
    for (final AddressInstruction(:from, :fromIndex, :to, :toIndex) in _inputInstructions) {
      if (from == to) {
        final gate = gates[from];
        final newInput = gate.input;
        newInput[toIndex] = gate.output[fromIndex];
        input = newInput;
      } else {
        final fromGate = from == -1 ? this : gates[from];
        final toGate = gates[to];
        final newInput = toGate.input;
        newInput[toIndex] = fromGate.output[fromIndex];
        toGate.input = newInput;
      }
    }
  }

  void _executeOutputInstruction(LogicData input) {
    for (final AddressInstruction(:from, :fromIndex, toIndex:outputIndex) in _outputInstructions) {
      if (from == -1) {
        final newOutput = output;
        newOutput[outputIndex] = input[fromIndex];
        output = newOutput;
      } else {
        final fromGate = gates[from];
        final newOutput = output;
        newOutput[outputIndex] = fromGate.output[fromIndex];
      }
    }
  }

  void removeInputAt(int value) {
    _inputInstructions.removeWhere((instruction) => instruction.from == AddressInstruction.parent && instruction.fromIndex == value);
    _outputInstructions.removeWhere((instruction) => instruction.from == AddressInstruction.parent && instruction.fromIndex == value);
    final newInput = input.removeAt(value);
    input = newInput;
  }

  void removeOutputAt(int value) {
    _outputInstructions.removeWhere((instruction) => instruction.toIndex == value);
    final newOutput = output.removeAt(value);
    output = newOutput;
  }
}
