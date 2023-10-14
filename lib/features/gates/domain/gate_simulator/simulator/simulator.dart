import 'package:logic_simulator/features/gates/domain/gate_simulator/bit.dart';
import 'package:logic_simulator/features/gates/domain/gate_simulator/component/component.dart';

abstract class Simulator {
  Simulator({required this.ticks});
  final int ticks;

  void run(covariant Component component);

  List<List<Bit>> get outputs;
}
