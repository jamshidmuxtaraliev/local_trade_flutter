import 'dart:core';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class ProductModel {
  @HiveField(0)
  final String tovarId;
  @HiveField(1)
  final String tovar;
  @HiveField(2)
  final String yedIzm;
  @HiveField(3)
  final String kategoriyaid;
  @HiveField(4)
  final String foto;
  @HiveField(5)
  final double ostatka;
  @HiveField(6)
  final double? sena;
  @HiveField(7)
  final double? optom_narx;
  @HiveField(8)
  final bool? type;
  @HiveField(9)
  final List<String> barcode;

  @JsonKey(ignore: true)
  var favorite = false;
  @JsonKey(ignore: true)
   double cartCount = 0.0;
  @JsonKey(ignore: true)
   double cartPrice = 0.0;
  @JsonKey(ignore: true)
   double cartTotalPrice = 0.0;

  ProductModel(this.tovarId, this.tovar, this.yedIzm, this.kategoriyaid, this.foto, this.ostatka, this.sena,
      this.optom_narx, this.type, this.barcode);

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
