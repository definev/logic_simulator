import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:logic_simulator/_internal/spacing.dart';
import 'package:logic_simulator/features/gates/domain/custom_gate.dart';
import 'package:logic_simulator/features/gates/domain/logic_data.dart';
import 'package:super_context_menu/super_context_menu.dart';

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
  final ValueChanged<LogicData> onDataChanged;
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
              onDataChanged(newData);
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
              child: GestureDetector(
                onTap: toggleCurrentIndex,
                child: Semantics(
                  label: label,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: switch (value) { true => Colors.red, false => Colors.grey },
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox.square(dimension: 50),
                  ),
                ),
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
    onDataChanged(data + LogicData.bit(false));
  }
}
