import 'package:json_annotation/json_annotation.dart';

part 'base_model.g.dart';

@JsonSerializable()
class BaseModel{
  final bool error;
  final String? message;
  final int? error_code;
  final dynamic data;
  BaseModel(this.error, this.message, this.error_code, this.data);

  factory BaseModel.fromJson(Map<String, dynamic> json) => _$BaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);
}