import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logic_simulator/features/editor/views/widgets/logic_gate_widget.dart';
import 'package:logic_simulator/features/gates/domain/custom_gate.dart';
import 'package:logic_simulator/features/gates/domain/logic_gate.dart';

class CustomLogicGatesField extends HookWidget {
  const CustomLogicGatesField({
    super.key,
    required this.gate,
    required this.onRemove,
    required this.onAdd,
  });

  final CustomGate gate;
  final ValueChanged<int> onRemove;
  final ValueChanged<LogicGate> onAdd;

  @override
  Widget build(BuildContext context) {
    final gates = useListenableSelector(gate, () => gate.gates);
    final gatesPosition = useListenableSelector(gate, () => gate.gatesPosition);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        return DragTarget<LogicGate>(
          onAcceptWithDetails: (details) {
            print(details.data);
            print(details.offset);
          },
          builder: (context, candidateData, rejectedData) => Stack(
            children: [
              for (final (gateIndex, position) in gatesPosition.indexed)
                Positioned.directional(
                  textDirection: TextDirection.ltr,
                  top: position.dy * size.height,
                  start: position.dx * size.width,
                  child: LogicGateWidget(
                    gates[gateIndex],
                    gateIndex: gateIndex,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
