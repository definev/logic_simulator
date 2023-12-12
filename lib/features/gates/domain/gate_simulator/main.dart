import 'dart:io';

import 'package:logic_simulator/features/gates/domain/gate_simulator/component/constants_bit.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/component/structural.dart';

import 'component/port_names.dart';
import 'simulator/utils.dart';
import 'vcd/vcd_file_simulator.dart';

Structural muxGate() {
  var cZero = CompIO.zero(2, 1);
  var gndvcc = CompIO(ConstantsBit());

  final portNames = PortNames(inputs: ['S1', 'S0'], outputs: ['Y']);
  final components = [cZero, gndvcc];

  // INPUTS
  cZero.addConnection(0, component: 1, index: 0);
  cZero.addConnection(1, component: 1, index: 1);

  // WIRE
  gndvcc.addConnection(0, component: 1, index: 2);
  gndvcc.addConnection(1, component: 1, index: 3);
  gndvcc.addConnection(1, component: 1, index: 4);
  gndvcc.addConnection(0, component: 1, index: 5);

  // OUTPUT
  return Structural(
    portNames: portNames,
    components: components,
    inputCount: 2,
    outputCount: 1,
    name: 'MUX-XOR',
  );
}

void main() {
  final newOr = muxGate();
  final simulator = FileVCDSimulator(
    ticks: 100,
    file: File('assets/vcd/or.vcd')..createSync(recursive: true),
    iterable: RepeatInputIterable(size: 2, repeatTime: 2),
  );
  simulator.run(newOr);
}
