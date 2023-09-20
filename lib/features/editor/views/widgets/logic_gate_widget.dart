import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logic_simulator/_internal/spacing.dart';
import 'package:logic_simulator/features/editor/views/widgets/bit_dot.dart';
import 'package:logic_simulator/features/gates/domain/logic_gate.dart';

class LogicGateWidget extends HookWidget {
  const LogicGateWidget(
    this.gate, {
    super.key,
    required this.gateIndex,
    required this.onOutputReceived,
  });

  final int gateIndex;
  final LogicGate gate;
  final ValueChanged<BitDotDataPair> onOutputReceived;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listenableGate = useListenable(gate);

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int index = 0; index < listenableGate.input.length; index++)
                () {
                  const mode = BitDotModes.input;
                  final data = BitDotData(from: gateIndex, index: index);
                  return Padding(
                    padding: EdgeInsets.all(Spacing.m.size),
                    child: BitDot(
                      key: ValueKey((mode, data)),
                      value: listenableGate.input[index],
                      data: data,
                      mode: mode,
                      size: Spacing.l.size,
                      onOutputReceived: (value) => onOutputReceived.call(
                        (from: value, to: data),
                      ),
                    ),
                  );
                }(),
            ],
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.secondary),
              color: theme.colorScheme.secondary,
            ),
            child: Padding(
              padding: EdgeInsets.all(Spacing.l.size),
              child: DefaultTextStyle(
                style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onSecondary),
                child: Text(listenableGate.name),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int index = 0; index < listenableGate.output.length; index++)
                Padding(
                  padding: EdgeInsets.all(Spacing.m.size),
                  child: BitDot(
                    value: listenableGate.output[index],
                    data: BitDotData(from: gateIndex, index: index),
                    mode: BitDotModes.output,
                    size: Spacing.l.size,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
