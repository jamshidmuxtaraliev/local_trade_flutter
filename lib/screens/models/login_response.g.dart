// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      json['login'] as String?,
      json['password'] as String?,
      json['sklad'] as String?,
      json['skladId'] as String?,
      json['registrirovan'] as bool?,
      json['adress'] as String?,
      json['phone'] as String?,
      json['email'] as String?,
      json['token'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'login': instance.login,
      'password': instance.password,
      'sklad': instance.sklad,
      'skladId': instance.skladId,
      'registrirovan': instance.registrirovan,
      'adress': instance.adress,
      'phone': instance.phone,
      'email': instance.email,
      'token': instance.token,
      'name': instance.name,
    };
