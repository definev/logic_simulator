sealed class Instruction {
  const Instruction();
}

class SetInstruction extends Instruction {
  const SetInstruction({required this.at, required this.atIndex, required this.to, required this.toIndex});

  factory SetInstruction.fromParent(
    int index, {
    required int to,
    required int toIndex,
  }) {
    return SetInstruction(
      at: -1,
      atIndex: index,
      to: to,
      toIndex: toIndex,
    );
  }

  factory SetInstruction.toParent(
    int index, {
    required int at,
    required int atIndex,
  }) {
    return SetInstruction(
      at: at,
      atIndex: atIndex,
      to: -1,
      toIndex: index,
    );
  }

  final int at;
  final int atIndex;
  final int to;
  final int toIndex;
}
