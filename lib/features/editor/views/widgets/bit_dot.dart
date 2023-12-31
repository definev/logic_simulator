import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logic_simulator/_internal/spacing.dart';
import 'package:logic_simulator/features/editor/application/bit_dot_context_map.dart';
import 'package:logic_simulator/features/editor/views/entity/dot_drag_position.dart';
import 'package:logic_simulator/features/editor/views/widgets/drag_line_painter.dart';
import 'package:logic_simulator/features/gates/domain/instruction.dart';
import 'package:logic_simulator/features/gates/domain/logic_data.dart';
import 'package:logic_simulator/utils/render_object.dart';
import 'package:super_context_menu/super_context_menu.dart';

enum BitDotModes { input, output }

class BitDotData extends Equatable {
  const BitDotData({required this.from, required this.index});

  final int from;
  final int index;

  @override
  List<Object?> get props => [from, index];
}

typedef OutputBitDotData = ({BitDotData data, int outputIndex});

typedef BitDotDataPair = ({BitDotData from, BitDotData to});

class BitDot extends HookConsumerWidget {
  const BitDot({
    super.key,
    this.label,
    required this.value,
    required this.data,
    required this.mode,
    this.size = 50,
    this.onOutputReceived,
    this.menuProvider,
    this.padding,
    this.onToggle,
  });

  final Bit value;
  final BitDotData data;
  final BitDotModes mode;
  final VoidCallback? onToggle;
  final ValueChanged<BitDotData>? onOutputReceived;

  final MenuProvider? menuProvider;
  final String? label;
  final double size;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final overlay = Overlay.of(context);
    final entry = useState<OverlayEntry?>(null);
    final dragPosition = useState<DotDragPosition?>(null);
    final dragInitialOffset = useRef<Offset?>(null);

    useEffect(
      () {
        final bitDotContextMapController = ref.read(bitDotContextMapProvider.notifier);
        Timer.run(() => bitDotContextMapController.update((mode, data), context));
        return () => Timer.run(() => bitDotContextMapController.remove((mode, data)));
      },
      [context],
    );

    Widget createButton() => GestureDetector(
          onTap: onToggle,
          child: Semantics(
            label: label,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: switch (value) { true => Colors.red, false => Colors.grey },
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(dimension: size),
            ),
          ),
        );

    Widget child;
    switch (mode) {
      case BitDotModes.input when data.from == AddressInstruction.parent:
      case BitDotModes.output when data.from != AddressInstruction.parent:
        child = Draggable<BitDotData>(
          data: data,
          dragAnchorStrategy: (draggable, context, position) {
            dragInitialOffset.value = position;
            final center = RenderObjectUtils.getCenter(context);
            return RenderObjectUtils.transformGlobalToLocal(context, center);
          },
          onDragStarted: () {
            final dot = RenderObjectUtils.getCenter(context);
            final drag = dragInitialOffset.value!;
            dragPosition.value = DotDragPosition(dot: dot, drag: drag);
            entry.value?.remove();
            entry.value = OverlayEntry(
              builder: (BuildContext context) {
                return ListenableBuilder(
                  listenable: dragPosition,
                  builder: (context, child) => DragLinePaint(
                    position: dragPosition.value!,
                    enabled: value,
                  ),
                );
              },
              opaque: false,
            );
            overlay.insert(entry.value!);
          },
          onDragEnd: (details) {
            entry.value?.remove();
            entry.value = null;
          },
          onDraggableCanceled: (velocity, offset) => entry.value?.remove(),
          onDragCompleted: () => entry.value?.remove(),
          onDragUpdate: (details) {
            dragPosition.value = dragPosition.value!.copyWith(
              drag: details.globalPosition,
            );
          },
          feedback: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: ColoredBox(
              color: theme.colorScheme.primaryContainer,
              child: SizedBox.square(
                dimension: size,
                child: Icon(Icons.add),
              ),
            ),
          ),
          child: createButton(),
        );
      case BitDotModes.input when data.from != AddressInstruction.parent:
      case BitDotModes.output when data.from == AddressInstruction.parent:
        child = DragTarget<BitDotData>(
          onAccept: (data) => onOutputReceived?.call(data),
          builder: (context, candidateData, rejectedData) => createButton(),
        );
      default:
        throw UnimplementedError();
    }

    child = Padding(
      padding: padding ?? EdgeInsets.all(Spacing.xs.size),
      child: child,
    );

    if (menuProvider case final menuProvider?) {
      child = ContextMenuWidget(
        menuProvider: menuProvider,
        child: child,
      );
    }

    return child;
  }
}
