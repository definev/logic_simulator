import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logic_simulator/features/editor/views/widgets/bit_dot.dart';
import 'package:logic_simulator/features/editor/views/widgets/gate_logic_data_bar.dart';
import 'package:logic_simulator/features/editor/views/widgets/data_connected_link_widget.dart';
import 'package:logic_simulator/features/gates/domain/custom_gate.dart';
import 'package:logic_simulator/features/gates/domain/instruction.dart';
import 'package:logic_simulator/features/gates/domain/logic_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'editor_view.g.dart';

@riverpod
class EditorGate extends _$EditorGate {
  @override
  Raw<CustomGate> build() {
    ref.onDispose(() => state.dispose());
    return CustomGate(
      gates: [],
      instructions: [],
      input: LogicData.bit(false),
      output: LogicData.bit(false),
    );
  }

  void setGate(CustomGate gate) => state = gate;
}

class EditorView extends HookConsumerWidget {
  const EditorView({
    super.key,
    this.gate,
  });

  final CustomGate? gate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(editorGateProvider);
    useEffect(
      () => switch (gate) {
        final gate? => () => Timer.run(() => ref.read(editorGateProvider.notifier).setGate(gate)),
        null => null,
      },
      [],
    );

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: Placeholder(),
          ),
          Expanded(
            child: GateEditor(current),
          ),
        ],
      ),
    );
  }
}

class GateEditor extends StatelessWidget {
  const GateEditor(this.gate, {super.key});

  final CustomGate gate;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: DataConnectedLinkWidget(gate: gate)),
        // Logic gate
        Positioned.fill(child: SizedBox()),
        // Link
        // Input & Output
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListenableBuilder(
              listenable: gate,
              builder: (context, _) => GateLogicDataBar(
                mode: BitDotModes.input,
                allowToggle: true,
                //
                data: gate.input,
                labelMap: gate.inputLabel,
                onDataChanged: (value) {
                  if (value.needCompute) {
                    gate.input = value.value;
                  } else {
                    gate.silentUpdateInput(value.value);
                  }
                },
                onLabelMapChanged: (value) => gate.inputLabel = value,
                onRemoveAt: (value) => gate.removeAt(
                  (
                    value.$1,
                    BitDotData(from: AddressInstruction.parent, index: value.$2),
                  ),
                ),
              ),
            ),
            ListenableBuilder(
              listenable: gate,
              builder: (context, _) => GateLogicDataBar(
                mode: BitDotModes.output,
                onOutputReceived: (value) {
                  final (:data, :outputIndex) = value;
                  gate.addAddressInstruction(
                    AddressInstruction.output(
                      from: data.from,
                      fromIndex: data.index,
                      outputIndex: outputIndex,
                    ),
                  );
                },
                //
                data: gate.output,
                labelMap: gate.outputLabel,
                onDataChanged: (value) => gate.output = value.value,
                onLabelMapChanged: (value) => gate.outputLabel = value,
                onRemoveAt: (value) => gate.removeAt((
                  value.$1,
                  BitDotData(from: AddressInstruction.parent, index: value.$2),
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
