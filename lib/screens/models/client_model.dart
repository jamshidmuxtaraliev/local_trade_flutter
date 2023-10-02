import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'client_model.g.dart';

@JsonSerializable()

class ClientModel{
  final String client;
  final int clientID;
  final String sum;
  final String dollar;
  @JsonKey(ignore: true)
  bool isOpen = false;

  ClientModel(this.client, this.clientID, this.sum, this.dollar);

  factory ClientModel.fromJson(Map<String, dynamic> json) => _$ClientModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClientModelToJson(this);
}
