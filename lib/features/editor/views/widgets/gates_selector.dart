import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logic_simulator/_internal/spacing.dart';
import 'package:logic_simulator/features/editor/application/saved_gates.dart';
import 'package:logic_simulator/features/editor/views/widgets/logic_gate_placeholder.dart';

class GatesSelector extends ConsumerWidget {
  const GatesSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedGates = ref.watch(savedGatesProvider);

    return ListView.separated(
      padding: EdgeInsets.all(Spacing.m.size),
      scrollDirection: Axis.horizontal,
      itemCount: savedGates.length,
      itemBuilder: (context, index) => LogicGatePlaceholder(savedGates[index]),
      separatorBuilder: (BuildContext context, int index) => Gap(Spacing.m.size),
    );
  }
}
