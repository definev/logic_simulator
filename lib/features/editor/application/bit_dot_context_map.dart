import 'package:flutter/material.dart';
import 'package:logic_simulator/features/editor/views/bit_dot.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bit_dot_context_map.g.dart';

typedef ModeBitDotData = (BitDotModes mode, BitDotData data);

@riverpod
class BitDotContextMap extends _$BitDotContextMap {
  @override
  Map<ModeBitDotData, BuildContext> build() {
    return {};
  }

  void remove(ModeBitDotData data) {
    final newState = {...state};
    newState.remove(data);
    state = newState;
  }

  void update(ModeBitDotData data, BuildContext context) {
    final newState = {...state};
    newState[data] = context;
    state = newState;
  }
}
