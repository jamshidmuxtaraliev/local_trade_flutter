import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'price_type_model.g.dart';

@JsonSerializable()

class PriceTypeModel{
 final int id;
 final String name;
 @JsonKey(ignore: true)
 bool checked = false;

  PriceTypeModel(this.id, this.name);

  factory PriceTypeModel.fromJson(Map<String, dynamic> json) => _$PriceTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$PriceTypeModelToJson(this);
}
