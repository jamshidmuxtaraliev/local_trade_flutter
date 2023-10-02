// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_bdm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseBdmModel _$BaseBdmModelFromJson(Map<String, dynamic> json) => BaseBdmModel(
      json['error'] as bool,
      json['message'] as String?,
      json['items'],
    );

Map<String, dynamic> _$BaseBdmModelToJson(BaseBdmModel instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'items': instance.items,
    };
