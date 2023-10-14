

import 'package:dart_vcd/dart_vcd.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/bit.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/vcd/vcd_writable_component.dart';

import 'component.dart';

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
