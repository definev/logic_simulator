import 'package:flutter_test/flutter_test.dart';
import 'package:logic_simulator/features/editor/views/bit_dot.dart';
import 'package:logic_simulator/features/gates/domain/custom_gate.dart';
import 'package:logic_simulator/features/gates/domain/instruction.dart';
import 'package:logic_simulator/features/gates/domain/logic_data.dart';

void main() {
  group('CustomGate', () {
    test('Wiring input to output', () {
      final gate = CustomGate(
        gates: [],
        input: LogicData.bit(false),
        output: LogicData.bit(false),
        instructions: [
          AddressInstruction.output(from: AddressInstruction.parent, fromIndex: 0, outputIndex: 0),
        ],
      );
      expect(gate.output, LogicData.bit(false), reason: 'output should be false');
      gate.input = LogicData.bit(true);
      expect(gate.output, LogicData.bit(true), reason: 'output should be true');
      gate.removeConnectionAt((BitDotModes.output, BitDotData(from: AddressInstruction.parent, index: 0)), forceReload: true);
      expect(gate.output, LogicData.bit(false), reason: 'output should be false');
    });
    test('Wiring mutiple output', () {
      final gate = CustomGate(
        gates: [],
        input: LogicData.bit(false),
        output: LogicData.generate(2, (index) => false),
        instructions: [
          AddressInstruction.output(from: AddressInstruction.parent, fromIndex: 0, outputIndex: 0),
          AddressInstruction.output(from: AddressInstruction.parent, fromIndex: 0, outputIndex: 1),
        ],
      );
      expect(gate.output, LogicData.generate(2, (index) => false), reason: 'output should be false');
      gate.input = LogicData.bit(true);
      expect(gate.output, LogicData.generate(2, (index) => true), reason: 'output should be true');
    });
    test('Wiring output and toggle input', () {
      final gate = CustomGate(
        gates: [],
        input: LogicData.fromBits(const [false, false, true, true]),
        output: LogicData.generate(6, (index) => false),
      );
      expect(gate.output, LogicData.generate(6, (index) => false), reason: 'output should be false');
      final instructions = [
        AddressInstruction.output(
          from: AddressInstruction.parent,
          fromIndex: 1,
          outputIndex: 1,
        ),
        AddressInstruction.output(
          from: AddressInstruction.parent,
          fromIndex: 2,
          outputIndex: 2,
        ),
        AddressInstruction.output(
          from: AddressInstruction.parent,
          fromIndex: 3,
          outputIndex: 3,
        ),
        AddressInstruction.output(
          from: AddressInstruction.parent,
          fromIndex: 0,
          outputIndex: 4,
        ),
      ];
      gate.instructions = instructions;
      expect(
        gate.output,
        LogicData.fromBits(const [false, false, true, true, false, false]),
        reason: 'output should be false',
      );
      gate.removeAt((BitDotModes.output, BitDotData(from: AddressInstruction.parent, index: 0)));
      expect(
        gate.output,
        LogicData.fromBits(const [false, true, true, false, false]),
        reason: 'output must be remove false in 0 index and stay same',
      );
      expect(
        gate.instructions,
        [
          AddressInstruction.output(
            from: AddressInstruction.parent,
            fromIndex: 1,
            outputIndex: 0,
          ),
          AddressInstruction.output(
            from: AddressInstruction.parent,
            fromIndex: 2,
            outputIndex: 1,
          ),
          AddressInstruction.output(
            from: AddressInstruction.parent,
            fromIndex: 3,
            outputIndex: 2,
          ),
          AddressInstruction.output(
            from: AddressInstruction.parent,
            fromIndex: 0,
            outputIndex: 3,
          ),
        ],
        reason: 'instructions must be rearrange because of remove output pin at index 0',
      );
    });
  });
}
