class PortNames {
  const PortNames({required this.inputs, required this.outputs});

  factory PortNames.fromDefault(int inputCount, int outputCount) {
    return PortNames(
      inputs: [for (int i = 0; i < inputCount; i++) 'i$i'],
      outputs: [for (int i = 0; i < outputCount; i++) 'o$i'],
    );
  }

  final List<String> inputs;
  final List<String> outputs;

  PortNames copyWith({
    List<String>? inputs,
    List<String>? outputs,
  }) {
    return PortNames(
      inputs: inputs ?? List.of(this.inputs),
      outputs: outputs ?? List.of(this.outputs),
    );
  }
}
