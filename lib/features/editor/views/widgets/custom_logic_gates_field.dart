import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logic_simulator/features/editor/views/widgets/logic_gate_widget.dart';
import 'package:logic_simulator/features/gates/domain/custom_gate.dart';
import 'package:logic_simulator/features/gates/domain/instruction.dart';
import 'package:logic_simulator/features/gates/domain/logic_gate.dart';
import 'package:logic_simulator/utils/render_object.dart';

class CustomLogicGatesField extends HookWidget {
  const CustomLogicGatesField({
    super.key,
    required this.gate,
    required this.onRemove,
    required this.onAdd,
    required this.onMove,
  });

  final CustomGate gate;
  final ValueChanged<int> onRemove;
  final ValueChanged<(LogicGate, Offset)> onAdd;
  final ValueChanged<(int, Offset)> onMove;

  Offset _normalizeOffset(Offset offset, Size size) {
    return Offset(
      offset.dx / size.width,
      offset.dy / size.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gates = useListenableSelector(gate, () => gate.gates);
    final gatesPosition = useListenableSelector(gate, () => gate.gatesPosition);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        void onGateMove(BuildContext context, BuildContext gateContext, Offset globalPosition, int gateIndex) {
          final gateLocalPoint = RenderObjectUtils.getSize(gateContext).center(Offset.zero);
          final canvasLocalPoint = RenderObjectUtils.transformGlobalToLocal(context, globalPosition);
          final localPoint = canvasLocalPoint - gateLocalPoint;

          final nomalizedPoint = _normalizeOffset(localPoint, size);
          onMove((gateIndex, nomalizedPoint));
        }

        return DragTarget<LogicGate>(
          onAcceptWithDetails: (details) {
            final localPoint = RenderObjectUtils.transformGlobalToLocal(context, details.offset);
            final nomalizedPoint = _normalizeOffset(localPoint, size);
            onAdd((details.data.clone(), nomalizedPoint));
          },
          builder: (context, candidateData, rejectedData) => Stack(
            children: [
              for (final (gateIndex, position) in gatesPosition.indexed)
                Positioned.directional(
                  textDirection: TextDirection.ltr,
                  top: position.dy * size.height,
                  start: position.dx * size.width,
                  child: Builder(
                    builder: (gateContext) => GestureDetector(
                      onPanStart: (details) => onGateMove(context, gateContext, details.globalPosition, gateIndex),
                      onPanUpdate: (details) => onGateMove(context, gateContext, details.globalPosition, gateIndex),
                      child: LogicGateWidget(
                        gates[gateIndex],
                        gateIndex: gateIndex,
                        onOutputReceived: (value) => gate.addAddressInstruction(
                          AddressInstruction.fromBitDotDataPair(value),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
