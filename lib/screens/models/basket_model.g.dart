// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasketModel _$BasketModelFromJson(Map<String, dynamic> json) => BasketModel(
      json['id'] as String,
      (json['count'] as num).toDouble(),
      (json['price'] as num).toDouble(),
      (json['totalPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$BasketModelToJson(BasketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
      'price': instance.price,
      'totalPrice': instance.totalPrice,
    };
