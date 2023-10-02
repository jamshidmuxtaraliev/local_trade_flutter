import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:local_trade_flutter/screens/models/make_order_product.dart';

import '../../utils/pref_utils.dart';

part 'make_order_model.g.dart';

@JsonSerializable()
class MakeOrderModel {
  String clientId;
   int type = PrefUtils.getPriceType();
   List<MakeOrderProduct> products;
   bool orderType;
   String login = PrefUtils.getUser()?.login??"";


  MakeOrderModel(this.clientId, this.products, this.orderType);

  factory MakeOrderModel.fromJson(Map<String, dynamic> json) => _$MakeOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$MakeOrderModelToJson(this);
}
