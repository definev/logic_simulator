import 'package:flutter/material.dart';
import 'package:logic_simulator/features/editor/views/widgets/bit_dot.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bit_dot_context_map.g.dart';

typedef ModeBitDotData = (BitDotModes mode, BitDotData data);
typedef BitDotContextMapData = ({BuildContext? parent, Map<ModeBitDotData, BuildContext> contextMap});

extension BitDotContextMapDataX on BitDotContextMapData {
  BitDotContextMapData copyWith({BuildContext? parent, Map<ModeBitDotData, BuildContext>? contextMap}) {
    return (parent: parent ?? this.parent, contextMap: contextMap ?? this.contextMap);
  }
}

@riverpod
class BitDotContextMap extends _$BitDotContextMap {
  @override
  BitDotContextMapData build() {
    return (parent: null, contextMap: {});
  }

  void setParent(BuildContext context) {
    state = state.copyWith(parent: context);
  }

  void remove(ModeBitDotData data) {
    final newState = {...state.contextMap};
    newState.remove(data);
    state = state.copyWith(contextMap: newState);
  }

  void update(ModeBitDotData data, BuildContext context) {
    final newState = {...state.contextMap};
    newState[data] = context;
    state = state.copyWith(contextMap: newState);
  }
}
