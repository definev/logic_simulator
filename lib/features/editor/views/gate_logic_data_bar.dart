import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:logic_simulator/_internal/spacing.dart';
import 'package:logic_simulator/features/editor/views/entity/dot_drag_position.dart';
import 'package:logic_simulator/features/editor/views/widgets/drag_line_painter.dart';
import 'package:logic_simulator/features/gates/domain/custom_gate.dart';
import 'package:logic_simulator/features/gates/domain/logic_data.dart';
import 'package:logic_simulator/utils/render_object.dart';
import 'package:super_context_menu/super_context_menu.dart';

typedef ComputeableLogicData = ({LogicData value, bool needCompute});

class GateLogicDataBar extends StatelessWidget {
  const GateLogicDataBar({
    super.key,
    required this.data,
    required this.labelMap,
    required this.onDataChanged,
    required this.onLabelMapChanged,
    required this.onRemoveAt,
    this.allowToggle = false,
  });

  final LogicData data;
  final LogicDataLabelMap labelMap;
  final ValueChanged<ComputeableLogicData> onDataChanged;
  final ValueChanged<LogicDataLabelMap> onLabelMapChanged;
  final ValueChanged<int> onRemoveAt;
  final bool allowToggle;

  double get barWidth => 50 + Spacing.xs.size * 2;

  @override
  Widget build(BuildContext context) {
    Widget child = SeparatedColumn(
      separatorBuilder: () => Gap(Spacing.l.size),
      padding: EdgeInsets.all(Spacing.xs.size),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int index = 0; index < data.length; index++)
          () {
            final value = data[index];
            final label = labelMap[index];

            void toggleCurrentIndex() {
              if (!allowToggle) return;
              final newData = data;
              newData[index] = !value;
              onDataChanged((value: newData, needCompute: true));
            }

            void deleteCurrentIndex() {
              onRemoveAt(index);
            }

            return ContextMenuWidget(
              menuProvider: (MenuRequest request) {
                return Menu(
                  children: [
                    MenuAction(
                      title: 'Toggle',
                      callback: toggleCurrentIndex,
                    ),
                    MenuAction(
                      title: 'Delete',
                      attributes: MenuActionAttributes(destructive: true),
                      callback: deleteCurrentIndex,
                    ),
                  ],
                );
              },
              child: BitValueDot(
                size: 50,
                label: label,
                value: value,
                onToggle: toggleCurrentIndex,
              ),
            );
          }(),
      ],
    );
    child = ConstrainedBox(
      constraints: BoxConstraints(minWidth: barWidth),
      child: child,
    );
    child = ColoredBox(
      color: Colors.black12,
      child: child,
    );

    child = GestureDetector(
      onTap: insertLogicData,
      child: child,
    );

    return child;
  }

  void insertLogicData() {
    onDataChanged((value: data + LogicData.bit(false), needCompute: false));
  }
}

class BitValueDot extends HookWidget {
  const BitValueDot({
    super.key,
    required this.label,
    required this.value,
    this.onToggle,
    required this.size,
  });

  final String? label;
  final Bit value;
  final VoidCallback? onToggle;
  final double size;

  @override
  Widget build(BuildContext context) {
    final overlay = Overlay.of(context);
    final entry = useState<OverlayEntry?>(null);
    final dragPosition = useState<DotDragPosition?>(null);
    final dragInitialOffset = useRef<Offset?>(null);

    return LongPressDraggable(
      dragAnchorStrategy: (draggable, context, position) {
        final center = RenderObjectUtils.getCenter(context);
        dragInitialOffset.value = position;
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
              builder: (context, child) => DragLinePaint(position: dragPosition.value!),
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
          color: Colors.green,
          child: SizedBox.square(
            dimension: size,
            child: Icon(Icons.add),
          ),
        ),
      ),
      child: GestureDetector(
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
      ),
    );
  }
}
