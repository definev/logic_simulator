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
    final (:parent, contextMap: nodes) = ref.watch(bitDotContextMapProvider);
    final listenedGate = useListenable(gate);
    useEffect(() {
      final bitDotContextMapNotifier = ref.read(bitDotContextMapProvider.notifier);
      Timer.run(() => bitDotContextMapNotifier.setParent(context));
      return null;
    }, [context]);

    return Stack(
      children: [
        for (final instruction in listenedGate.instructions)
          if (parent != null &&
              nodes[instruction.fromModesBitdotData] != null &&
              nodes[instruction.toModesBitdotData] != null)
            ConnectedLinkLine(
              instruction: instruction,
              parentContext: parent,
              fromNode: nodes[instruction.fromModesBitdotData]!,
              toNode: nodes[instruction.toModesBitdotData]!,
              enabled: listenedGate.getValueFrom(instruction),
            ),
      ],
    );
  }
}

class ConnectedLinkLine extends HookWidget {
  const ConnectedLinkLine({
    super.key,
    required this.parentContext,
    required this.instruction,
    required this.fromNode,
    required this.toNode,
    required this.enabled,
  });

  final BuildContext parentContext;
  final AddressInstruction instruction;
  final BuildContext fromNode;
  final BuildContext toNode;
  final bool enabled;

  DotDragPosition? get position {
    if (!(fromNode.mounted && toNode.mounted)) return null;
    final dot = RenderObjectUtils.getCenter(fromNode, parentContext);
    final drag = RenderObjectUtils.getCenter(toNode, parentContext);

    return DotDragPosition(dot: dot, drag: drag);
  }

  @override
  Widget build(BuildContext context) {
    final dragPosition = useState<DotDragPosition?>(null);
    Timer.run(() => dragPosition.value = position ?? dragPosition.value);

    return Positioned.fill(
      child: DragLinePaint(
        position: dragPosition.value ?? DotDragPosition(dot: Offset.zero, drag: Offset.zero),
        enabled: enabled,
      ),
    );
  }
}
