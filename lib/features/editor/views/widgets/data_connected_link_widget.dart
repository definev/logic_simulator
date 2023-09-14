import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logic_simulator/features/editor/application/bit_dot_context_map.dart';
import 'package:logic_simulator/features/editor/views/entity/dot_drag_position.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_connected_link_widget.g.dart';

@riverpod
class _ConnectedLinks extends _$ConnectedLinks {
  @override
  List<DotDragPosition> build() {
    return [];
  }
}

class DataConnectedLinkWidget extends ConsumerWidget {
  const DataConnectedLinkWidget({super.key});

  static void addLinkFromWidgetRef(WidgetRef ref, DotDragPosition position) {
    ref.read(_connectedLinksProvider);
  }

  static void addLinkFromRef(Ref ref, DotDragPosition position) {
    ref.read(_connectedLinksProvider);
  }

  static void removeLinkFromWidgetRef(WidgetRef ref, DotDragPosition position) {
    ref.read(_connectedLinksProvider);
  }

  static void removeLinkFromRef(Ref ref, DotDragPosition position) {
    ref.read(_connectedLinksProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodes = ref.watch(bitDotContextMapProvider);
    return Column(
      children: [
        for (final MapEntry(:key, :value) in nodes.entries) Text('key: $key, value: $value'),
      ],
    );
  }
}
