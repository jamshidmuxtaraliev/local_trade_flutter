import 'dart:core';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class CategoryModel{
  @HiveField(0)
  final String KategoriyaId;
  @HiveField(1)
  final String Kategoriya;
  @HiveField(2)
  final String foto;

  CategoryModel(this.KategoriyaId, this.Kategoriya, this.foto);

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
