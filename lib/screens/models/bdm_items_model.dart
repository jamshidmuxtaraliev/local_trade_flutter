
import 'package:json_annotation/json_annotation.dart';

import 'bdm_app_model.dart';

part 'bdm_items_model.g.dart';

@JsonSerializable()
class BdmItemsModel{
  final String id;
  final String secret_name;
  final String ipaddress;
  final String ipport;
  final String href_address;
  final String bdate;
  final String edate;
  final String mobile_username;
  final String mobile_password;
  final String client_version_code;
  final List<BdmAppModel> apps;
  BdmItemsModel(this.id, this.secret_name, this.ipaddress, this.ipport, this.href_address, this.bdate, this.edate, this.mobile_username, this.mobile_password, this.client_version_code, this.apps);

  factory BdmItemsModel.fromJson(Map<String, dynamic> json) => _$BdmItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$BdmItemsModelToJson(this);
}