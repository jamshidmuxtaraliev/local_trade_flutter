import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'make_order_product.g.dart';

@JsonSerializable()
class MakeOrderProduct {
  final String pid;
  final double count;
  final double price;
  final double summa;


  MakeOrderProduct(this.pid, this.count, this.price, this.summa);

  factory MakeOrderProduct.fromJson(Map<String, dynamic> json) => _$MakeOrderProductFromJson(json);

  Map<String, dynamic> toJson() => _$MakeOrderProductToJson(this);
}
