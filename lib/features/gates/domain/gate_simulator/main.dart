import 'dart:io';

import 'package:logic_simulator/features/gates/domain/gate_simulator/component/or.dart';

import 'simulator/utils.dart';
import 'vcd/vcd_file_simulator.dart';

void main() {
  final newOr = Or();
  final simulator = FileVCDSimulator(
    ticks: 100,
    file: File('assets/vcd/or.vcd')..createSync(recursive: true),
    iterable: RepeatInputIterable(size: 2, repeatTime: 2),
  );
  simulator.run(newOr);
}
