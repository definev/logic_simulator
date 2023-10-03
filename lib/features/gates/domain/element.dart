import 'package:dart_vcd/dart_vcd.dart';

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

mixin VCDWritable on Component {
  VCDHandler writeInternalComponent(VCDWriter writer, int scope) => VCDHandler(id: {});

  void writeInternalSignal(VCDWriter writer, int scope, VCDHandler handler) {}
}

class Structural with Component, VCDWritable {
  Structural({
    required this.components,
    required this.inputCount,
    required this.outputCount,
    required this.name,
  })  : assert(components.first.input.length == inputCount),
        assert(components.first.output.length == outputCount);

  final List<CompIO> components;
  @override
  final int inputCount;
  @override
  final int outputCount;
  @override
  final String name;

  @override
  List<Bit> update(List<Bit> input) {
    // Propagate input
    propagateInput(input);
    // Update components
    updateComponents();
    // Propagate internal signals
    propagateSignals();
    // Return the component output
    return output;
  }

  @override
  VCDHandler writeInternalComponent(VCDWriter writer, int scope) {
    final vh = VCDHandler(id: {});
    final isParentScope = scope == 0;
    if (isParentScope) {
      var index = InstanceIndex(instance: scope, port: 0);
      final instanceName = '$name-$scope';
      writer.addModule(instanceName);
    }

    return vh;
  }

  @override
  void writeInternalSignal(VCDWriter writer, int scope, VCDHandler handler) {}
}

extension StructuralX on Structural {
  void propagate(int outComponentIndex) {
    final outComponent = components[outComponentIndex];
    final connections = outComponent.connections.clone();
    for (final (outIndex, input) in connections.indexed) {
      for (final (:inputIndex, componentIndex: inputComponentIndex) in input) {
        final inputComponent = components[inputComponentIndex];
        inputComponent.input[inputIndex] = outComponent.output[outIndex];
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
      final CompIO(:input, :component) = compTo;
      compTo.output = component.update(input);
    }
  }

  List<Bit> get output => List.of(components.first.input);
}

class CompIO {
  CompIO._({
    required this.component,
    required this.input,
    required this.output,
    required this.connections,
  });

  factory CompIO(Component component) {
    final input = List.generate(component.inputCount, (index) => Bit.unknown);
    final output = List.generate(component.outputCount, (index) => Bit.unknown);
    final connections = List.generate(component.outputCount, (index) => <ComponentIndex>[]);
    return CompIO._(component: component, input: input, output: output, connections: connections);
  }

  factory CompIO.zero(int inputCount, int outputCount) {
    final component = Nand(inputCount: 0);
    final input = List.generate(inputCount, (index) => Bit.unknown);
    final output = List.generate(outputCount, (index) => Bit.unknown);
    final connections = List.generate(inputCount, (index) => <ComponentIndex>[]);
    return CompIO._(component: component, input: input, output: output, connections: connections);
  }

  final Component component;
  List<Bit> input;
  List<Bit> output;
  List<List<ComponentIndex>> connections;
}

extension ConnectionsX on List<List<ComponentIndex>> {
  List<List<ComponentIndex>> clone() => List.generate(length, (index) => [...this[index]]);
}

extension CompToConnectionX on CompIO {
  void addConnection(int outputIndex, {required int componentIndex, required int inputIndex}) {
    connections[outputIndex].add((componentIndex: componentIndex, inputIndex: inputIndex));
  }
}

typedef ComponentIndex = ({int componentIndex, int inputIndex});

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

Structural orGate() {
  final c = <CompIO>[];
  final cZero = CompIO.zero(2, 1);
  final nandA = CompIO(Nand(inputCount: 1));
  final nandB = CompIO(Nand(inputCount: 1));
  final nandC = CompIO(Nand(inputCount: 2));

  cZero.addConnection(0, componentIndex: 1, inputIndex: 0);
  cZero.addConnection(1, componentIndex: 2, inputIndex: 0);

  nandA.addConnection(0, componentIndex: 3, inputIndex: 0);
  nandB.addConnection(0, componentIndex: 3, inputIndex: 1);
  nandC.addConnection(0, componentIndex: 0, inputIndex: 0);

  c.add(cZero);
  c.add(nandA);
  c.add(nandB);
  c.add(nandC);

  return Structural(components: c, inputCount: 2, outputCount: 1, name: 'OR2');
}

abstract class Simulator {
  Simulator({required this.ticks});
  final int ticks;

  void run(Component component, List<List<Bit>> inputs);

  List<List<Bit>> get outputs;
}

class VCDSimulator extends Simulator {
  VCDSimulator({required super.ticks});

  StringBufferVCDWriter writer = StringBufferVCDWriter();

  List<List<Bit>> _outputs = [];
  @override
  List<List<Bit>> get outputs => _outputs;

  @override
  void run(Component component, List<List<Bit>> inputs) {
    if (component is! VCDWritable) return;
    writer.flush();
    _outputs = [];
    writer.timescale(1, TimescaleUnit.ns);
    final vh = component.writeInternalComponent(writer, 0);
    writer.enddefinitions();

    writer.begin(SimulationCommand.dumpvars);
    for (final id in vh.id.values) {
      writer.changeScalar(id, Value.x);
    }
    writer.end();

    for (int t = 0; t < ticks; t++) {
      writer.timestamp(t);
      component.update(inputs[t]);
      component.writeInternalSignal(writer, 0, vh);
    }
    writer.timestamp(ticks);
  }
}

class InstanceIndex {
  const InstanceIndex({required this.instance, required this.port});

  final int instance;
  final int port;

  @override
  String toString() => 'InstanceIndex(instance: $instance, port: $port)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InstanceIndex && other.instance == instance && other.port == port;
  }

  @override
  int get hashCode => Object.hash(instance, port);
}

class VCDHandler {
  final Map<InstanceIndex, IDCode> id;

  VCDHandler({required this.id});
}

void main() {
  final nandA = Nand(inputCount: 1);
  final nandB = Nand(inputCount: 1);
  final nandC = Nand(inputCount: 2);
  final nandD = Nand(inputCount: 5);
  final or = Or(nandA: nandA, nandB: nandB, nandC: nandC);
  final and = And(inputCount: 5, nand: nandC);
  final newOr = orGate();
  // print(or.truthTable);
  // print(nandC.truthTable);
  // print(and.truthTable);
  // print(nandD.truthTable);
  print(newOr.truthTable);
}
