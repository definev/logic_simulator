// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_gate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomGate _$CustomGateFromJson(Map<String, dynamic> json) => CustomGate(
      gates: (json['gates'] as List<dynamic>)
          .map((e) =>
              const LogicGateConverter().fromJson(e as Map<String, dynamic>))
          .toList(),
      gatesPosition: (json['gates_position'] as List<dynamic>)
          .map((e) => const OffsetConverter().fromJson(e as List<double>))
          .toList(),
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map(
                  (e) => AddressInstruction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      inputLabel: (json['input_label'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), e as String),
      ),
      outputLabel: (json['output_label'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), e as String),
      ),
      type: $enumDecodeNullable(_$LogicGateTypeEnumMap, json['type']) ??
          LogicGateType.custom,
      input: const LogicDataConverter().fromJson(json['input'] as List<bool>),
      output: const LogicDataConverter().fromJson(json['output'] as List<bool>),
    )..name = json['name'] as String;

Map<String, dynamic> _$CustomGateToJson(CustomGate instance) =>
    <String, dynamic>{
      'type': _$LogicGateTypeEnumMap[instance.type]!,
      'input': const LogicDataConverter().toJson(instance.input),
      'output': const LogicDataConverter().toJson(instance.output),
      'gates': instance.gates.map(const LogicGateConverter().toJson).toList(),
      'gates_position':
          instance.gatesPosition.map(const OffsetConverter().toJson).toList(),
      'instructions': instance.instructions,
      'input_label':
          instance.inputLabel.map((k, e) => MapEntry(k.toString(), e)),
      'output_label':
          instance.outputLabel.map((k, e) => MapEntry(k.toString(), e)),
      'name': instance.name,
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
