import 'package:json_annotation/json_annotation.dart';

part 'base_bdm_model.g.dart';

@JsonSerializable()
class BaseBdmModel{
  final bool error;
  final String? message;
  final dynamic items;
  BaseBdmModel(this.error, this.message, this.items);

  factory BaseBdmModel.fromJson(Map<String, dynamic> json) => _$BaseBdmModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseBdmModelToJson(this);
}