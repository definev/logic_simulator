import 'package:logic_simulator/features/gates/domain/gate_simulator/bit.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/component/component.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/component/port_names.dart';

class ConstantsBit with Component {
  ConstantsBit();

  @override
  PortNames get portNames => const PortNames(inputs: [], outputs: ['o0', 'o1', 'oX']);

  @override
  int get inputCount => 0;

  @override
  int get outputCount => 3;

  @override
  String get name => 'VCC-GND';

  @override
  List<Bit> update(List<Bit> input) {
    assert(input.isEmpty);
    return [Bit.zero, Bit.one, Bit.unknown];
  }
}
