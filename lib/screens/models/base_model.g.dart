// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseModel _$BaseModelFromJson(Map<String, dynamic> json) => BaseModel(
      json['error'] as bool,
      json['message'] as String?,
      json['error_code'] as int?,
      json['data'],
    );

Map<String, dynamic> _$BaseModelToJson(BaseModel instance) => <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'error_code': instance.error_code,
      'data': instance.data,
    };
