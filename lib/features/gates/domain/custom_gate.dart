// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:logic_simulator/features/editor/application/bit_dot_context_map.dart';
import 'package:logic_simulator/features/editor/views/bit_dot.dart';
import 'package:logic_simulator/features/gates/domain/logic_data.dart';

import 'instruction.dart';
import 'logic_gate.dart';

typedef LogicDataLabelMap = Map<int, String>;

class CustomGate extends LogicGate {
  CustomGate({
    required this.gates,
    List<AddressInstruction> instructions = const [],
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

  late List<AddressInstruction> _instructions;
  set instructions(List<AddressInstruction> value) {
    _instructions = value;
  }

  List<AddressInstruction> get instructions => _instructions;

  void addAddressInstruction(AddressInstruction instruction) {
    _instructions.removeWhere((inst) => inst.to == instruction.to);
    _instructions.add(instruction);
    output = compute();
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
    _executeInstructions(input ?? this.input);
    for (final gate in gates) {
      gate.output = gate.compute();
    }
    _executeInstructions(input ?? this.input);
    return output;
  }

  void _executeInstructions(LogicData input) {
    for (final instruction in _instructions) {
      final AddressInstruction(:from, :fromIndex, :to, :toIndex) = instruction;
      Bit value;
      if (from == AddressInstruction.parent) {
        value = input[fromIndex];
      } else {
        final fromGate = gates[from];
        value = fromGate.input[fromIndex];
      }

      if (to == AddressInstruction.parent) {
        final newOutput = output;
        newOutput[toIndex] = value;
        output = newOutput;
      } else {
        final toGate = gates[to];
        final newOutput = toGate.output;
        newOutput[toIndex] = value;
        output = newOutput;
      }
    }
  }

  void removeAt(ModeBitDotData data) {
    final (mode, bitData) = data;
    switch (mode) {
      case BitDotModes.input:
        _instructions.removeWhere((inst) => inst.from == bitData.from && inst.fromIndex == bitData.index);
        silentUpdateInput(input.removeAt(bitData.index));
        output = compute();

      case BitDotModes.output:
        _instructions.removeWhere((inst) => inst.to == bitData.from && inst.toIndex == bitData.index);
        output = output.removeAt(bitData.index);
    }
  }

  Bit getInputAt(int from, int fromIndex) {
    if (from == AddressInstruction.parent) {
      return input[fromIndex];
    } else {
      final fromGate = gates[from];
      return fromGate.input[fromIndex];
    }
  }
}
