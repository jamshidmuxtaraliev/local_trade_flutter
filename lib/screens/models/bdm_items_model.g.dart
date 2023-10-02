// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bdm_items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BdmItemsModel _$BdmItemsModelFromJson(Map<String, dynamic> json) =>
    BdmItemsModel(
      json['id'] as String,
      json['secret_name'] as String,
      json['ipaddress'] as String,
      json['ipport'] as String,
      json['href_address'] as String,
      json['bdate'] as String,
      json['edate'] as String,
      json['mobile_username'] as String,
      json['mobile_password'] as String,
      json['client_version_code'] as String,
      (json['apps'] as List<dynamic>)
          .map((e) => BdmAppModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BdmItemsModelToJson(BdmItemsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'secret_name': instance.secret_name,
      'ipaddress': instance.ipaddress,
      'ipport': instance.ipport,
      'href_address': instance.href_address,
      'bdate': instance.bdate,
      'edate': instance.edate,
      'mobile_username': instance.mobile_username,
      'mobile_password': instance.mobile_password,
      'client_version_code': instance.client_version_code,
      'apps': instance.apps,
    };
