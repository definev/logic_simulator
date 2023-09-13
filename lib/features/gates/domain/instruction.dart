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

  bool get isInput => to == parent;
  bool get isOutput => from == parent;

  @override
  String toString() => 'AddressInstruction(from: $from, fromIndex: $fromIndex, to: $to, toIndex: $toIndex)';
}
