import 'package:logic_simulator/features/gates/domain/gate_simulator/component/structural.dart';

import 'nand.dart';

class Or extends Structural {
  Or._({
    required super.components,
    super.inputCount = 2,
    super.outputCount = 1,
    super.name = 'OR',
  });

  factory Or() {
    final components = <CompIO>[];
    final cZero = CompIO.zero(2, 1);
    final nandA = CompIO(Nand(inputCount: 1));
    final nandB = CompIO(Nand(inputCount: 1));
    final nandC = CompIO(Nand(inputCount: 2));

    cZero.addConnection(0, component: 1, index: 0);
    cZero.addConnection(1, component: 2, index: 0);

    nandA.addConnection(0, component: 3, index: 0);
    nandB.addConnection(0, component: 3, index: 1);
    nandC.addConnection(0, component: 0, index: 0);

    components.add(cZero);
    components.add(nandA);
    components.add(nandB);
    components.add(nandC);

    return Or._(components: components, inputCount: 2, name: 'OR2', outputCount: 1);
  }
}
