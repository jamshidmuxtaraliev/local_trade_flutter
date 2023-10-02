import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()

class LoginResponse{
  final String? login;
  final String? password;
  final String? sklad;
  final String? skladId;
  final bool? registrirovan;
  final String? adress;
  final String? phone;
  final String? email;
  final String? token;
  final String? name;

  LoginResponse(this.login, this.password, this.sklad, this.skladId, this.registrirovan, this.adress, this.phone, this.email, this.token, this.name);

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
