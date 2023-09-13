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
      to: -1,
      toIndex: outputIndex,
    );
  }

  static const parent = -1;

  final int from;
  final int fromIndex;
  final int to;
  final int toIndex;

  bool get isInput => to == -1;
  bool get isOutput => from == -1;

  @override
  String toString() => 'AddressInstruction(from: $from, fromIndex: $fromIndex, to: $to, toIndex: $toIndex)';
}
