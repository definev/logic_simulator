import 'package:logic_simulator/features/gates/domain/gate_simulator/bit.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/component/port_names.dart';

mixin Component {
  List<Bit> update(List<Bit> input);

  int get inputCount;
  int get outputCount => 1;

  late PortNames portNames = PortNames.fromDefault(inputCount, outputCount);

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
