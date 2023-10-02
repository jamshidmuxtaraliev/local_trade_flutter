// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'make_order_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MakeOrderProduct _$MakeOrderProductFromJson(Map<String, dynamic> json) =>
    MakeOrderProduct(
      json['pid'] as String,
      (json['count'] as num).toDouble(),
      (json['price'] as num).toDouble(),
      (json['summa'] as num).toDouble(),
    );

Map<String, dynamic> _$MakeOrderProductToJson(MakeOrderProduct instance) =>
    <String, dynamic>{
      'pid': instance.pid,
      'count': instance.count,
      'price': instance.price,
      'summa': instance.summa,
    };
