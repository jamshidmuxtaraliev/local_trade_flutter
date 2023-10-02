// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientModel _$ClientModelFromJson(Map<String, dynamic> json) => ClientModel(
      json['client'] as String,
      json['clientID'] as int,
      json['sum'] as String,
      json['dollar'] as String
    );

Map<String, dynamic> _$ClientModelToJson(ClientModel instance) =>
    <String, dynamic>{
      'client': instance.client,
      'clientID': instance.clientID,
      'sum': instance.sum,
      'dollar': instance.dollar,
    };
