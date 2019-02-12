// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRequestBody _$AuthRequestBodyFromJson(Map<String, dynamic> json) {
  return AuthRequestBody(
      grantType: json['grant_type'] as String,
      scope: json['scope'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      refreshToken: json['refresh_token'] as String,
      guestUserId: json['guestUserId'] as int,
      assertion: json['assertion'] as String,
      openid: json['openid'] as String,
      ffToken: json['ff_token'] as String,
      token: json['token'] as String,
      tokenTypeHint: json['token_type_hint'] as String);
}

Map<String, dynamic> _$AuthRequestBodyToJson(AuthRequestBody instance) =>
    <String, dynamic>{
      'grant_type': instance.grantType,
      'scope': instance.scope,
      'username': instance.username,
      'password': instance.password,
      'refresh_token': instance.refreshToken,
      'guestUserId': instance.guestUserId,
      'assertion': instance.assertion,
      'openid': instance.openid,
      'ff_token': instance.ffToken,
      'token': instance.token,
      'token_type_hint': instance.tokenTypeHint
    };
