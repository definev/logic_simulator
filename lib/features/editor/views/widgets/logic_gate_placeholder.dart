import 'package:flutter/material.dart';
import 'package:logic_simulator/_internal/spacing.dart';
import 'package:logic_simulator/features/gates/domain/logic_gate.dart';

class LogicGatePlaceholder extends StatelessWidget {
  const LogicGatePlaceholder(
    this.gate, {
    super.key,
  });

  final LogicGate gate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget child = DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.secondary, width: 2),
        color: theme.cardColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(Spacing.m.size),
        child: Text(gate.name),
      ),
    );

    return Center(
      child: Draggable<LogicGate>(
        data: gate,
        feedback: Material(child: child),
        child: child,
      ),
    );
  }
}
