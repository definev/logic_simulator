// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:logic_simulator/features/editor/application/bit_dot_context_map.dart';
import 'package:logic_simulator/features/editor/views/widgets/bit_dot.dart';
import 'package:logic_simulator/features/gates/domain/json/logic_gate_converter.dart';
import 'package:logic_simulator/features/gates/domain/logic_data.dart';
import 'package:logic_simulator/features/gates/domain/logic_gate_type.dart';
import 'package:logic_simulator/utils/json/offset_converter.dart';

import 'instruction.dart';
import 'logic_gate.dart';

part 'custom_gate.g.dart';

typedef LogicDataLabelMap = Map<int, String>;

@JsonSerializable()
@OffsetConverter()
@LogicGateConverter()
@LogicDataConverter()
class CustomGate extends LogicGate {
  CustomGate({
    required List<LogicGate> gates,
    required List<Offset> gatesPosition,
    List<AddressInstruction> instructions = const [],
    LogicDataLabelMap? inputLabel,
    LogicDataLabelMap? outputLabel,
    super.type = LogicGateType.custom,
    required super.input,
    required super.output,
  })  : assert(gates.length == gatesPosition.length, 'gates and gatesPosition must have the same length'),
        _inputLabel = inputLabel ?? {},
        _outputLabel = outputLabel ?? {},
        _gates = gates,
        _gatesPosition = gatesPosition {
    gates.map((e) => e.addListener(notifyListeners));
    this.instructions = instructions;
  }

  factory CustomGate.fromJson(Map<String, dynamic> json) => _$CustomGateFromJson(json);
  Map<String, dynamic> toJson() => _$CustomGateToJson(this);

  @override
  CustomGate clone() {
    return CustomGate(
      gates: [for (final gate in gates) gate.clone()],
      gatesPosition: [...gatesPosition],
      input: input.clone(),
      output: output.clone(),
      inputLabel: Map.from(inputLabel),
      outputLabel: Map.from(outputLabel),
      instructions: [...instructions],
    );
  }

  final List<LogicGate> _gates;
  List<LogicGate> get gates => _gates;
  void removeGateAt(int index) {
    _gates.removeAt(index);
    _gatesPosition.removeAt(index);
    notifyListeners();
  }

  void addGate(LogicGate gate, Offset position) {
    _gates.add(gate);
    _gatesPosition.add(position);
    notifyListeners();
  }

  List<Offset> _gatesPosition;
  List<Offset> get gatesPosition => _gatesPosition;
  void moveGate(int gateIndex, Offset offset) {
    final newGatesPosition = List<Offset>.from(_gatesPosition);
    newGatesPosition[gateIndex] = offset;
    _gatesPosition = newGatesPosition;
    notifyListeners();
  }

  late List<AddressInstruction> _instructions;
  set instructions(List<AddressInstruction> value) {
    _instructions = value;
    output = compute();
  }

  List<AddressInstruction> get instructions => _instructions;
  List<AddressInstruction> get customGateInputInstructions =>
      _instructions.where((inst) => inst.from == AddressInstruction.parent).toList();
  List<AddressInstruction> get customGateOutputInstructions =>
      _instructions.where((inst) => inst.to == AddressInstruction.parent).toList();
  List<AddressInstruction> get childGatesInstructions => _instructions
      .where((inst) => inst.from != AddressInstruction.parent && inst.to != AddressInstruction.parent)
      .toList();

  void addAddressInstruction(AddressInstruction instruction) {
    _instructions.removeWhere((inst) => inst.to == instruction.to && inst.toIndex == instruction.toIndex);
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
    input ??= this.input;
    output = output.reset();
    final head = customGateInputInstructions;
    final middle = childGatesInstructions;
    final tail = customGateOutputInstructions;

    void compute() {
      for (final gate in gates) {
        gate.output = gate.compute();
      }
    }

    _executeInstructions(head, input);
    compute();
    _executeInstructions(middle, input);
    compute();
    _executeInstructions(_instructions, input);
    compute();
    _executeInstructions(tail, input);

    return output;
  }

  @override
  void dumpLog() {
    log('name: $name');
    log('input: $input');
    log('----' * 20);
    for (final gate in gates) {
      log('gate: ${gate.name}');
      gate.dumpLog();
    }
    log('----' * 20);
    log('output: $output');
  }

  void _executeInstructions(List<AddressInstruction> instructions, LogicData input) {
    for (final instruction in instructions) {
      final AddressInstruction(:to, :toIndex) = instruction;
      Bit value = getValueFrom(instruction);

      if (to == AddressInstruction.parent) {
        output = output.updateAt(toIndex, value);
      } else {
        final toGate = gates[to];
        toGate.silentUpdateInput(toGate.input.updateAt(toIndex, value));
      }
    }
  }

  void removeConnectionAt(ModeBitDotData data, {bool forceReload = false}) {
    final (mode, bitData) = data;
    switch (mode) {
      case BitDotModes.input:
        _instructions.removeWhere((inst) => inst.from == bitData.from && inst.fromIndex == bitData.index);
        _instructions = _instructions.map((inst) {
          if (inst.from == AddressInstruction.parent) {
            if (inst.fromIndex > bitData.index) {
              return inst.copyWith(fromIndex: inst.fromIndex - 1);
            }
          }
          return inst;
        }).toList();
      case BitDotModes.output:
        _instructions.removeWhere((inst) => inst.to == bitData.from && inst.toIndex == bitData.index);
        if (bitData.from == AddressInstruction.parent) {
          _instructions = _instructions.map((inst) {
            if (inst.to == AddressInstruction.parent) {
              if (inst.toIndex > bitData.index) {
                return inst.copyWith(toIndex: inst.toIndex - 1);
              }
            }
            return inst;
          }).toList();
        }
    }
    if (forceReload) output = compute();
  }

  void removeAt(ModeBitDotData data) {
    removeConnectionAt(data);
    final (mode, bitData) = data;
    switch (mode) {
      case BitDotModes.input:
        input = input.removeAt(bitData.index);
      case BitDotModes.output:
        output = output.removeAt(bitData.index);
    }
  }

  Bit getValueFrom(AddressInstruction instruction) {
    final AddressInstruction(:from, :fromIndex) = instruction;
    Bit value;
    if (from == AddressInstruction.parent) {
      value = input[fromIndex];
    } else {
      final fromGate = gates[from];
      value = fromGate.output[fromIndex];
    }
    return value;
  }

  Bit getValueAt(ModeBitDotData data) {
    final (mode, bitData) = data;
    switch (mode) {
      case BitDotModes.input:
        return input[bitData.index];
      case BitDotModes.output:
        return output[bitData.index];
    }
  }
}
