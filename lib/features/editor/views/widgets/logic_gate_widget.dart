import 'package:flutter/material.dart';
import 'package:logic_simulator/_internal/spacing.dart';
import 'package:logic_simulator/features/editor/views/widgets/bit_dot.dart';
import 'package:logic_simulator/features/gates/domain/logic_gate.dart';

class LogicGateWidget extends StatelessWidget {
  const LogicGateWidget(
    this.gate, {
    super.key,
    required this.gateIndex,
  });

  final int gateIndex;
  final LogicGate gate;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int index = 0; index < gate.input.length; index++)
                Padding(
                  padding: EdgeInsets.all(Spacing.m.size),
                  child: BitDot(
                    value: gate.input[index],
                    data: BitDotData(from: gateIndex, index: index),
                    mode: BitDotModes.input,
                    size: 10,
                  ),
                ),
            ],
          ),
          Text(gate.name),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int index = 0; index < gate.output.length; index++)
                Padding(
                  padding: EdgeInsets.all(Spacing.m.size),
                  child: BitDot(
                    value: gate.output[index],
                    data: BitDotData(from: gateIndex, index: index),
                    mode: BitDotModes.output,
                    size: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
