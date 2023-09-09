sealed class Instruction {
  const Instruction();
}

class InputInstruction extends Instruction {
  const InputInstruction({required this.from, required this.fromIndex, required this.to, required this.toIndex});

  final int from;
  final int fromIndex;
  final int to;
  final int toIndex;
}

class OutputInstruction extends Instruction {
  const OutputInstruction({required this.from, required this.fromIndex, required this.outputIndex});

  final int from;
  final int fromIndex;
  final int outputIndex;
}
