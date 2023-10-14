import 'package:logic_simulator/features/gates/domain/gate_simulator/bit.dart';

import 'component.dart';
import 'nand.dart';

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
