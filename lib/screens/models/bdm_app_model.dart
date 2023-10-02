import 'package:json_annotation/json_annotation.dart';

part 'bdm_app_model.g.dart';

@JsonSerializable()
class BdmAppModel{
  final String name;
  BdmAppModel(this.name);

  factory BdmAppModel.fromJson(Map<String, dynamic> json) => _$BdmAppModelFromJson(json);

  Map<String, dynamic> toJson() => _$BdmAppModelToJson(this);
}