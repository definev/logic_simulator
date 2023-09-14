import 'package:flutter/material.dart';
import 'package:logic_simulator/features/editor/views/bit_dot.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bit_dot_context_map.g.dart';

@riverpod
class BitDotContextMap extends _$BitDotContextMap {
  @override
  Map<BitDotData, BuildContext> build() {
    return {};
  }

  void remove(BitDotData data) {
    state = state..remove(data);
  }

  void update(BitDotData data, BuildContext context) {
    state = state..[data] = context;
    print(state);
  }
}
