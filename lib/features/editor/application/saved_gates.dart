

import 'package:logic_simulator/features/gates/domain/logic_gate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saved_gates.g.dart';

@riverpod
List<LogicGate> savedGates(SavedGatesRef ref) {
  return [
    ANDGate(),
    ORGate(),
    NOTGate(),
    XORGate(),
    NANDGate(),
  ];
}
