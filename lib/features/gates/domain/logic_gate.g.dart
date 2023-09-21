// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logic_gate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ANDGate _$ANDGateFromJson(Map<String, dynamic> json) => ANDGate()
  ..input = LogicData.fromJson(json['input'] as Map<String, dynamic>)
  ..output = LogicData.fromJson(json['output'] as Map<String, dynamic>);

Map<String, dynamic> _$ANDGateToJson(ANDGate instance) => <String, dynamic>{
      'input': instance.input,
      'output': instance.output,
    };

ORGate _$ORGateFromJson(Map<String, dynamic> json) => ORGate()
  ..input = LogicData.fromJson(json['input'] as Map<String, dynamic>)
  ..output = LogicData.fromJson(json['output'] as Map<String, dynamic>);

Map<String, dynamic> _$ORGateToJson(ORGate instance) => <String, dynamic>{
      'input': instance.input,
      'output': instance.output,
    };

NORGate _$NORGateFromJson(Map<String, dynamic> json) => NORGate()
  ..input = LogicData.fromJson(json['input'] as Map<String, dynamic>)
  ..output = LogicData.fromJson(json['output'] as Map<String, dynamic>);

Map<String, dynamic> _$NORGateToJson(NORGate instance) => <String, dynamic>{
      'input': instance.input,
      'output': instance.output,
    };

NOTGate _$NOTGateFromJson(Map<String, dynamic> json) => NOTGate()
  ..input = LogicData.fromJson(json['input'] as Map<String, dynamic>)
  ..output = LogicData.fromJson(json['output'] as Map<String, dynamic>);

Map<String, dynamic> _$NOTGateToJson(NOTGate instance) => <String, dynamic>{
      'input': instance.input,
      'output': instance.output,
    };

XORGate _$XORGateFromJson(Map<String, dynamic> json) => XORGate()
  ..input = LogicData.fromJson(json['input'] as Map<String, dynamic>)
  ..output = LogicData.fromJson(json['output'] as Map<String, dynamic>);

Map<String, dynamic> _$XORGateToJson(XORGate instance) => <String, dynamic>{
      'input': instance.input,
      'output': instance.output,
    };

NANDGate _$NANDGateFromJson(Map<String, dynamic> json) => NANDGate()
  ..input = LogicData.fromJson(json['input'] as Map<String, dynamic>)
  ..output = LogicData.fromJson(json['output'] as Map<String, dynamic>);

Map<String, dynamic> _$NANDGateToJson(NANDGate instance) => <String, dynamic>{
      'input': instance.input,
      'output': instance.output,
    };
