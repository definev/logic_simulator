import 'dart:io';

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

extension BitToValueConverter on Bit {
  Value get bitValue => switch (this) {
        Bit.zero => Value.v0,
        Bit.one => Value.v1,
        Bit.unknown => Value.x,
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

  void writeInternalSignals(VCDWriter writer, int scope, VCDHandler handler);
}

class Structural with Component, VCDWritable {
  Structural({
    required this.components,
    required this.inputCount,
    required this.outputCount,
    required this.name,
  })  : assert(components.first.input.length == outputCount),
        assert(components.first.output.length == inputCount);

  final List<CompIO> components;
  @override
  final int inputCount;
  @override
  final int outputCount;
  @override
  final String name;

  @override
  List<Bit> update(List<Bit> input) {
    assert(input.length == inputCount);
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
      for (int i = 0; i < inputCount; i++) {
        vh.id[index] = writer.addWire(1, '$instanceName-i$i');
        index = index.copyWith(port: index.port + 1);
      }

      for (int i = 0; i < outputCount; i++) {
        vh.id[index] = writer.addWire(1, '$instanceName-o$i');
        index = index.copyWith(port: index.port + 1);
      }

      scope += 1;
    }

    for (final comp in components.skip(1).where((c) => FileVCDSimulator.VCD_SHOW_NAND || !Nand.isNand(c.component))) {
      var index = InstanceIndex(instance: scope, port: 0);
      final CompIO(:component) = comp;
      if (component is! VCDWritable) continue;
      final instanceName = '${comp.component.name}-$scope';
      writer.addModule(instanceName);
      for (int i = 0; i < component.inputCount; i++) {
        vh.id[index] = writer.addWire(1, '$instanceName-i$i');
        index = index.copyWith(port: index.port + 1);
      }

      for (int i = 0; i < component.outputCount; i++) {
        vh.id[index] = writer.addWire(1, '$instanceName-o$i');
        index = index.copyWith(port: index.port + 1);
      }

      scope += 1;
      final ch = component.writeInternalComponent(writer, scope);
      vh.id.addAll(ch.id);
      writer.upscope();
    }

    if (isParentScope) {
      writer.upscope();
    }

    return vh;
  }

  InstanceIndex writeVcdSignals(
    VCDWriter writer,
    InstanceIndex index, {
    required VCDHandler handler,
    required List<Bit> signal1,
    required List<Bit> signal2,
  }) {
    for (final bit in signal1) {
      final id = handler.id[index]!;
      writer.changeScalar(id, bit.bitValue);
      index = index.copyWith(port: index.port + 1);
    }

    for (final bit in signal2) {
      final id = handler.id[index]!;
      writer.changeScalar(id, bit.bitValue);
      index = index.copyWith(port: index.port + 1);
    }

    return index;
  }

  @override
  void writeInternalSignals(VCDWriter writer, int scope, VCDHandler handler) {
    final isParentScope = scope == 0;

    if (isParentScope) {
      final input = List.of(components.first.output);
      final output = List.of(components.first.input);
      final index = InstanceIndex(instance: scope, port: 0);
      writeVcdSignals(writer, index, handler: handler, signal1: input, signal2: output);
      scope += 1;
    }

    for (final comp in components.skip(1).where((c) => FileVCDSimulator.VCD_SHOW_NAND || !Nand.isNand(c.component))) {
      final CompIO(:component) = comp;
      if (component is! VCDWritable) continue;
      final input = List<Bit>.from(comp.input);
      final output = List<Bit>.from(comp.output);
      final index = InstanceIndex(instance: scope, port: 0);
      writeVcdSignals(writer, index, handler: handler, signal1: input, signal2: output);
      scope += 1;

      component.writeInternalSignals(writer, scope, handler);
    }
  }
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
    final input = List.generate(outputCount, (index) => Bit.unknown);
    final output = List.generate(inputCount, (index) => Bit.unknown);
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

class Nand with Component, VCDWritable {
  Nand({required this.inputCount});
  @override
  final int inputCount;

  @override
  int get outputCount => 1;

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

  @override
  VCDHandler writeInternalComponent(VCDWriter writer, int scope) {
    final vh = VCDHandler(id: {});
    final instanceName = '$name$inputCount-$scope';
    var index = InstanceIndex(instance: scope, port: 0);
    for (int i = 0; i < inputCount; i++) {
      vh.id[index] = writer.addWire(1, '$instanceName-i$i');
      index = index.copyWith(port: index.port + 1);
    }
    for (int i = 0; i < outputCount; i++) {
      vh.id[index] = writer.addWire(1, '$instanceName-o$i');
      index = index.copyWith(port: index.port + 1);
    }
    return vh;
  }

  @override
  void writeInternalSignals(VCDWriter writer, int scope, VCDHandler handler) {}

  static bool isNand(Component component) {
    return component.name == 'NAND';
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

  void run(covariant Component component);

  List<List<Bit>> get outputs;
}

class FileVCDSimulator extends Simulator {
  FileVCDSimulator({
    required super.ticks,
    required this.file,
    required this.iterable,
  });

  static const VCD_SHOW_NAND = true;

  final File file;
  final RepeatInputIterable iterable;

  StringBufferVCDWriter writer = StringBufferVCDWriter();

  List<List<Bit>> _outputs = [];
  @override
  List<List<Bit>> get outputs => _outputs;

  @override
  void run(VCDWritable component) {
    _outputs = [];
    writer.flush();

    writer.timescale(1, TimescaleUnit.ns);
    final handler = component.writeInternalComponent(writer, 0);
    writer.addModule('clk');
    final clk = writer.addWire(1, 'clk');
    writer.upscope();

    writer.enddefinitions();

    // Write the initial values
    writer.begin(SimulationCommand.dumpvars);
    writer.changeScalar(clk, Bit.one.bitValue);
    for (final id in handler.id.values) {
      writer.changeScalar(id, Bit.unknown.bitValue);
    }
    writer.end();

    final inputCount = component.inputCount;
    var clkOn = true;
    for (final (t, currentInput) in iterable.take(ticks).indexed) {
      writer.timestamp(t);
      final inputStartAt = currentInput.length - inputCount;
      component.update(currentInput.sublist(inputStartAt, currentInput.length));

      component.writeInternalSignals(writer, 0, handler);
      writer.changeScalar(clk, clkOn ? Bit.one.bitValue : Bit.zero.bitValue);
      clkOn = !clkOn;
    }
    writer.timestamp(ticks);

    file.writeAsStringSync(writer.result);
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

  InstanceIndex copyWith({
    int? instance,
    int? port,
  }) {
    return InstanceIndex(
      instance: instance ?? this.instance,
      port: port ?? this.port,
    );
  }
}

class VCDHandler {
  final Map<InstanceIndex, IDCode> id;

  VCDHandler({required this.id});
}

class RepeatInputIterable extends Iterable<List<Bit>> {
  const RepeatInputIterable({
    required this.size,
    required this.repeatTime,
  });

  final int size;
  final int repeatTime;

  @override
  Iterator<List<Bit>> get iterator => RepeatInputIterator(size: size, repeatTime: repeatTime);
}

class RepeatInputIterator implements Iterator<List<Bit>> {
  RepeatInputIterator({
    required this.size,
    required this.repeatTime,
  }) {
    _current = List.generate(size, (index) => Bit.zero);
  }

  final int size;
  final int repeatTime;
  int _currentTime = 0;

  List<Bit> _current = [];

  @override
  List<Bit> get current => _current;

  static List<Bit> _nextInput(List<Bit> input) {
    final nextInput = List.of(input);
    var i = nextInput.length;
    var carry = true;
    while (carry && i > 0) {
      i -= 1;
      switch (nextInput[i]) {
        case Bit.zero:
          carry = false;
          nextInput[i] = Bit.one;
        case Bit.one:
          carry = true;
          nextInput[i] = Bit.zero;
        case Bit.unknown:
          carry = true;
      }
    }
    return nextInput;
  }

  @override
  bool moveNext() {
    if (_currentTime == repeatTime) {
      _currentTime = 0;
      _current = _nextInput([..._current]);
    }
    _currentTime++;
    return true;
  }
}

void main() {
  final newOr = orGate();
  final simulator = FileVCDSimulator(
    ticks: 100,
    file: File('assets/vcd/or.vcd')..createSync(recursive: true),
    iterable: RepeatInputIterable(size: 2, repeatTime: 2),
  );
  simulator.run(newOr);
}
