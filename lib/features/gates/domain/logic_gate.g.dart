// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logic_gate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ANDGate _$ANDGateFromJson(Map<String, dynamic> json) => ANDGate()
  ..type = $enumDecode(_$LogicGateTypeEnumMap, json['type'])
  ..input = const LogicDataConverter().fromJson(json['input'] as List)
  ..output = const LogicDataConverter().fromJson(json['output'] as List);

Map<String, dynamic> _$ANDGateToJson(ANDGate instance) => <String, dynamic>{
      'type': _$LogicGateTypeEnumMap[instance.type]!,
      'input': const LogicDataConverter().toJson(instance.input),
      'output': const LogicDataConverter().toJson(instance.output),
    };

const _$LogicGateTypeEnumMap = {
  LogicGateType.and: 'and',
  LogicGateType.or: 'or',
  LogicGateType.nor: 'nor',
  LogicGateType.not: 'not',
  LogicGateType.xor: 'xor',
  LogicGateType.nand: 'nand',
  LogicGateType.custom: 'custom',
};

ORGate _$ORGateFromJson(Map<String, dynamic> json) => ORGate()
  ..type = $enumDecode(_$LogicGateTypeEnumMap, json['type'])
  ..input = const LogicDataConverter().fromJson(json['input'] as List)
  ..output = const LogicDataConverter().fromJson(json['output'] as List);

Map<String, dynamic> _$ORGateToJson(ORGate instance) => <String, dynamic>{
      'type': _$LogicGateTypeEnumMap[instance.type]!,
      'input': const LogicDataConverter().toJson(instance.input),
      'output': const LogicDataConverter().toJson(instance.output),
    };

NORGate _$NORGateFromJson(Map<String, dynamic> json) => NORGate()
  ..type = $enumDecode(_$LogicGateTypeEnumMap, json['type'])
  ..input = const LogicDataConverter().fromJson(json['input'] as List)
  ..output = const LogicDataConverter().fromJson(json['output'] as List);

Map<String, dynamic> _$NORGateToJson(NORGate instance) => <String, dynamic>{
      'type': _$LogicGateTypeEnumMap[instance.type]!,
      'input': const LogicDataConverter().toJson(instance.input),
      'output': const LogicDataConverter().toJson(instance.output),
    };

NOTGate _$NOTGateFromJson(Map<String, dynamic> json) => NOTGate()
  ..type = $enumDecode(_$LogicGateTypeEnumMap, json['type'])
  ..input = const LogicDataConverter().fromJson(json['input'] as List)
  ..output = const LogicDataConverter().fromJson(json['output'] as List);

Map<String, dynamic> _$NOTGateToJson(NOTGate instance) => <String, dynamic>{
      'type': _$LogicGateTypeEnumMap[instance.type]!,
      'input': const LogicDataConverter().toJson(instance.input),
      'output': const LogicDataConverter().toJson(instance.output),
    };

XORGate _$XORGateFromJson(Map<String, dynamic> json) => XORGate()
  ..type = $enumDecode(_$LogicGateTypeEnumMap, json['type'])
  ..input = const LogicDataConverter().fromJson(json['input'] as List)
  ..output = const LogicDataConverter().fromJson(json['output'] as List);

Map<String, dynamic> _$XORGateToJson(XORGate instance) => <String, dynamic>{
      'type': _$LogicGateTypeEnumMap[instance.type]!,
      'input': const LogicDataConverter().toJson(instance.input),
      'output': const LogicDataConverter().toJson(instance.output),
    };

NANDGate _$NANDGateFromJson(Map<String, dynamic> json) => NANDGate()
  ..type = $enumDecode(_$LogicGateTypeEnumMap, json['type'])
  ..input = const LogicDataConverter().fromJson(json['input'] as List)
  ..output = const LogicDataConverter().fromJson(json['output'] as List);

Map<String, dynamic> _$NANDGateToJson(NANDGate instance) => <String, dynamic>{
      'type': _$LogicGateTypeEnumMap[instance.type]!,
      'input': const LogicDataConverter().toJson(instance.input),
      'output': const LogicDataConverter().toJson(instance.output),
    };
