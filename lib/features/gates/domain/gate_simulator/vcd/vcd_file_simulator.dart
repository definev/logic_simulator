import 'dart:io';

import 'package:dart_vcd/dart_vcd.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/bit.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/simulator/simulator.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/simulator/utils.dart';

import 'vcd_writable_component.dart';

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
