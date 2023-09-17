import 'package:logic_simulator/features/editor/application/bit_dot_context_map.dart';
import 'package:logic_simulator/features/editor/views/bit_dot.dart';

sealed class Instruction {
  const Instruction();
}

class AddressInstruction extends Instruction {
  const AddressInstruction({
    required this.from,
    required this.fromIndex,
    required this.to,
    required this.toIndex,
  });

  factory AddressInstruction.output({
    required int from,
    required int fromIndex,
    required int outputIndex,
  }) {
    return AddressInstruction(
      from: from,
      fromIndex: fromIndex,
      //
      to: parent,
      toIndex: outputIndex,
    );
  }

  static const parent = -1;

  final int from;
  final int fromIndex;
  final int to;
  final int toIndex;

  @override
  String toString() => 'AddressInstruction(from: $from, fromIndex: $fromIndex, to: $to, toIndex: $toIndex)';
}

extension AddressInstructionExt on AddressInstruction {
  ModeBitDotData get fromModesBitdotData {
    return (
      from == AddressInstruction.parent ? BitDotModes.input : BitDotModes.output,
      BitDotData(
        from: from,
        index: fromIndex,
      ),
    );
  }

  ModeBitDotData get toModesBitdotData {
    return (
      to == AddressInstruction.parent ? BitDotModes.output : BitDotModes.input,
      BitDotData(
        from: to,
        index: toIndex,
      ),
    );
  }
}
