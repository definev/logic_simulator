import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logic_simulator/features/editor/views/widgets/bit_dot.dart';
import 'package:logic_simulator/features/gates/domain/custom_gate.dart';
import 'package:logic_simulator/features/gates/domain/instruction.dart';
import 'package:logic_simulator/features/gates/domain/logic_data.dart';

CustomGate _generateCustomGate({
  required int inputPinCount,
  required int outputPinCount,
  required ValueChanged<CustomGate> onSetup,
  List<AddressInstruction> instructions = const [],
}) {
  final gate = CustomGate(
    gates: [],
    input: LogicData.generate(inputPinCount, (index) => false),
    output: LogicData.generate(outputPinCount, (index) => false),
    instructions: instructions,
  );
  onSetup(gate);
  return gate;
}

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
      gate.removeConnectionAt((BitDotModes.output, BitDotData(from: AddressInstruction.parent, index: 0)),
          forceReload: true);
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
    test('Remove output will decrease the toIndex by one if toIndex greater than the removed PIN', () {
      const inputPinCount = 4;
      const outputPinCount = 6;
      final gate = _generateCustomGate(
        inputPinCount: inputPinCount,
        outputPinCount: outputPinCount,
        instructions: [
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
        ],
        onSetup: (gate) {
          gate.input = gate.input.toggleAt(0);
          gate.input = gate.input.toggleAt(1);
        },
      );

      expect(
        gate.output,
        LogicData.fromBits(const [false, true, false, false, true, false]),
        reason: 'output must be true in 1 and 4 index',
      );

      gate.removeAt((BitDotModes.output, BitDotData(from: AddressInstruction.parent, index: 0)));

      /// EXPECT OUTPUT
      expect(
        gate.output,
        LogicData.fromBits(const [true, false, false, true, false]),
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
    test('Remove input will decrease the fromIndex by one if fromIndex greater than the removed PIN', () {
      const inputPinCount = 4;
      const outputPinCount = 6;
      final gate = _generateCustomGate(
        inputPinCount: inputPinCount,
        outputPinCount: outputPinCount,
        instructions: [
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
        ],
        onSetup: (gate) {
          gate.input = gate.input.toggleAt(0);
          gate.input = gate.input.toggleAt(1);
        },
      );

      expect(
        gate.output,
        LogicData.fromBits(const [false, true, false, false, true, false]),
        reason: 'output must be true in 1 and 4 index',
      );

      gate.removeAt((BitDotModes.input, BitDotData(from: AddressInstruction.parent, index: 0)));
      expect(
        gate.output,
        LogicData.fromBits(const [false, true, false, false, false, false]),
        reason: 'the output must be the same except the PIN 4',
      );
      expect(
        gate.instructions,
        [
          AddressInstruction.output(
            from: AddressInstruction.parent,
            fromIndex: 0,
            outputIndex: 1,
          ),
          AddressInstruction.output(
            from: AddressInstruction.parent,
            fromIndex: 1,
            outputIndex: 2,
          ),
          AddressInstruction.output(
            from: AddressInstruction.parent,
            fromIndex: 2,
            outputIndex: 3,
          ),
        ],
        reason: 'all instructions must be removed because of remove input pin at index 0',
      );
      gate.removeAt((BitDotModes.input, BitDotData(from: AddressInstruction.parent, index: 1)));
      expect(
        gate.output,
        LogicData.fromBits(const [false, true, false, false, false, false]),
        reason: 'the output must be the same except the PIN 4',
      );
      expect(
        gate.instructions,
        [
          AddressInstruction.output(
            from: AddressInstruction.parent,
            fromIndex: 0,
            outputIndex: 1,
          ),
          AddressInstruction.output(
            from: AddressInstruction.parent,
            fromIndex: 1,
            outputIndex: 3,
          ),
        ],
        reason: 'all instructions must be removed because of remove input pin at index 1',
      );
    });
  });
}
