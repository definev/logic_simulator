import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logic_simulator/features/editor/application/bit_dot_context_map.dart';
import 'package:logic_simulator/features/editor/views/entity/dot_drag_position.dart';
import 'package:logic_simulator/features/editor/views/widgets/drag_line_painter.dart';
import 'package:logic_simulator/features/gates/domain/custom_gate.dart';
import 'package:logic_simulator/features/gates/domain/instruction.dart';
import 'package:logic_simulator/utils/render_object.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_connected_link_widget.g.dart';

@riverpod
class _ConnectedLinks extends _$ConnectedLinks {
  @override
  List<DotDragPosition> build() {
    return [];
  }
}

class DataConnectedLinkWidget extends HookConsumerWidget {
  const DataConnectedLinkWidget({
    super.key,
    required this.gate,
  });

  final CustomGate gate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodes = ref.watch(bitDotContextMapProvider);
    final listenedGate = useListenable(gate);

    return Stack(
      children: [
        for (final instruction in listenedGate.instructions)
          ConnectedLinkLine(
            instruction: instruction,
            fromNode: nodes[instruction.fromModesBitdotData]!,
            toNode: nodes[instruction.toModesBitdotData]!,
            enabled: gate.getInputAt(instruction.from, instruction.fromIndex),
          ),
      ],
    );
  }
}

class ConnectedLinkLine extends HookWidget {
  const ConnectedLinkLine({
    super.key,
    required this.instruction,
    required this.fromNode,
    required this.toNode,
    required this.enabled,
  });

  final AddressInstruction instruction;
  final BuildContext fromNode;
  final BuildContext toNode;
  final bool enabled;

  DotDragPosition get position {
    final dot = RenderObjectUtils.getCenter(fromNode);
    final drag = RenderObjectUtils.getCenter(toNode);

    return DotDragPosition(dot: dot, drag: drag);
  }

  @override
  Widget build(BuildContext context) {
    final dragPosition = useState<DotDragPosition?>(null);
    Timer.run(() => dragPosition.value = position);

    return Positioned.fill(
      child: DragLinePaint(
        position: dragPosition.value ?? DotDragPosition(dot: Offset.zero, drag: Offset.zero),
        enabled: enabled,
      ),
    );
  }
}
