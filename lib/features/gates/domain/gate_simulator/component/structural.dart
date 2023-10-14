


import 'package:dart_vcd/dart_vcd.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/bit.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/vcd/vcd_file_simulator.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/vcd/vcd_writable_component.dart';

import 'component.dart';
import 'nand.dart';

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