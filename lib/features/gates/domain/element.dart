enum Bit {
  zero,
  one,
  unknown;

  String get name => switch (this) {
        Bit.zero => '0',
        Bit.one => '1',
        Bit.unknown => '?',
      };
}

mixin Component {
  List<Bit> update(List<Bit> input);
  int get inputCount;
  int get outputCount => 1;
  String get name;

  String get truthTable {
    StringBuffer buffer = StringBuffer();
    List<Bit> input = List.generate(inputCount, (index) => Bit.zero);
    for (int index = 0; index < inputCount; index++) {
      for (final bit in [Bit.zero, Bit.one]) {
        input[index] = bit;
        final output = update(input);
        buffer.writeln('${input.map((e) => e.name).join(' ')} -> ${output.map((e) => e.name).join(' ')}');
      }
    }
    return buffer.toString();
  }
}

class Structural with Component {
  Structural({
    required this.components,
    required this.inputCount,
    required this.outputCount,
    required this.name,
  })  : assert(components.first.input.length == inputCount),
        assert(components.first.output.length == outputCount),
        assert(components.last.output.length == inputCount);

  final List<CompTo> components;
  @override
  final int inputCount;
  @override
  final int outputCount;
  @override
  final String name;

  @override
  List<Bit> update(List<Bit> input) {
    propagateInput(input);
    updateComponents();
    propagateSignals();
    return output;
  }
}

extension StructuralX on Structural {
  void propagate(int componentId) {
    final outComponent = components[componentId];
    final connections = outComponent.connections.clone();
    for (final (outIndex, toInfo) in connections.indexed) {
      for (final i in toInfo) {
        final inputComponent = components[i.componentId];
        inputComponent.input[i.inputId] = outComponent.output[outIndex];
      }
    }
  }

  void propagateInput(List<Bit> input) {
    components.first.output = List.of(input);
    propagate(0);
  }

  void propagateSignals() {
    for (int index = 1; index < components.length; index++) {
      propagate(index);
    }
  }

  void updateComponents() {
    for (final compTo in components.skip(1)) {
      final CompTo(:input, :component) = compTo;
      compTo.output = component.update(input);
    }
  }

  List<Bit> get output => List.of(components.first.input);
}

class CompTo {
  CompTo._({
    required this.component,
    required this.input,
    required this.output,
    required this.connections,
  });

  factory CompTo(Component component) {
    final input = List.generate(component.inputCount, (index) => Bit.unknown);
    final output = List.generate(component.outputCount, (index) => Bit.unknown);
    final connections = List.generate(component.outputCount, (index) => <Index>[]);
    return CompTo._(component: component, input: input, output: output, connections: connections);
  }

  final Component component;
  List<Bit> input;
  List<Bit> output;
  List<List<Index>> connections;
}

extension ConnectionsX on List<List<Index>> {
  List<List<Index>> clone() => List.generate(length, (index) => [...this[index]]);
}

extension CompToConnectionX on CompTo {
  void addConnection(int outputId, int componentId, int inputId) {
    connections[outputId].add((componentId: componentId, inputId: inputId));
  }
}

typedef Index = ({int componentId, int inputId});

class Nand with Component {
  Nand({required this.inputCount});
  @override
  final int inputCount;

  @override
  String get name => 'NAND';

  @override
  List<Bit> update(List<Bit> input) {
    assert(input.length == inputCount);
    Bit x = Bit.zero;
    for (final a in input) {
      switch (a) {
        case Bit.zero:
          return [Bit.one];
        case Bit.one:
          x = Bit.zero;
          continue;
        case Bit.unknown:
          break;
      }
    }
    return [x];
  }
}

class Or with Component {
  Or({
    required this.nandA,
    required this.nandB,
    required this.nandC,
  });

  final Nand nandA;
  final Nand nandB;
  final Nand nandC;

  @override
  int get inputCount => 2;

  @override
  String get name => 'OR';

  @override
  List<Bit> update(List<Bit> input) {
    final a = input[0];
    final b = input[1];
    final notA = nandA.update([a])[0];
    final notB = nandB.update([b])[0];
    return nandC.update([notA, notB]);
  }
}

class And with Component {
  And({
    required this.inputCount,
    required this.nand,
  });

  final Nand nand;

  @override
  final int inputCount;

  @override
  String get name => 'AND';

  @override
  List<Bit> update(List<Bit> input) {
    assert(input.length == inputCount);
    var a = input[0];
    var b = input[1];
    var x = nand.update([a, b])[0];
    for (int index = 2; index < inputCount; index++) {
      a = nand.update([x, x])[0];
      b = input[index];
      x = nand.update([a, b])[0];
    }
    return nand.update([x, x]);
  }
}

void main() {
  final nandA = Nand(inputCount: 1);
  final nandB = Nand(inputCount: 1);
  final nandC = Nand(inputCount: 2);
  final nandD = Nand(inputCount: 5);
  final or = Or(nandA: nandA, nandB: nandB, nandC: nandC);
  final and = And(inputCount: 5, nand: nandC);
  print(or.truthTable);
  print(nandC.truthTable);
  print(and.truthTable);
  print(nandD.truthTable);
}
