// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'make_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MakeOrderModel _$MakeOrderModelFromJson(Map<String, dynamic> json) =>
    MakeOrderModel(
      json['clientId'] as String,
      (json['products'] as List<dynamic>)
          .map((e) => MakeOrderProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['orderType'] as bool,
    )
      ..type = json['type'] as int
      ..login = json['login'] as String;

Map<String, dynamic> _$MakeOrderModelToJson(MakeOrderModel instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'type': instance.type,
      'products': instance.products,
      'orderType': instance.orderType,
      'login': instance.login,
    };
