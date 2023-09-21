// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logic_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogicData _$LogicDataFromJson(Map<String, dynamic> json) => LogicData(
      json['length'] as int,
      data: (json['data'] as List<dynamic>).map((e) => e as bool).toList(),
    );

Map<String, dynamic> _$LogicDataToJson(LogicData instance) => <String, dynamic>{
      'length': instance.length,
      'data': instance.data,
    };
