import 'package:flutter/material.dart';
import 'package:logic_simulator/_internal/spacing.dart';
import 'package:logic_simulator/features/editor/views/bit_dot.dart';
import 'package:logic_simulator/features/gates/domain/custom_gate.dart';
import 'package:logic_simulator/features/gates/domain/instruction.dart';
import 'package:logic_simulator/features/gates/domain/logic_data.dart';
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
    required this.mode,
    this.onOutputReceived,
    this.allowToggle = false,
  });

  final LogicData data;
  final LogicDataLabelMap labelMap;
  final ValueChanged<ComputeableLogicData> onDataChanged;
  final ValueChanged<LogicDataLabelMap> onLabelMapChanged;
  final ValueChanged<(BitDotModes, int)> onRemoveAt;
  final ValueChanged<OutputBitDotData>? onOutputReceived;
  final bool allowToggle;
  final BitDotModes mode;

  double get barWidth => 50 + Spacing.xs.size * 2;

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
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
              onRemoveAt((mode, index));
            }

            Menu menuProvider(MenuRequest request) {
              return Menu(
                children: [
                  if (allowToggle)
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
            }

            return BitDot(
              data: BitDotData(from: AddressInstruction.parent, index: index),
              menuProvider: menuProvider,
              mode: mode,
              label: label,
              value: value,
              onToggle: toggleCurrentIndex,
              onOutputReceived: (value) => onOutputReceived?.call((data: value, outputIndex: index)),
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
