// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthToken.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthToken _$AuthTokenFromJson(Map<String, dynamic> json) {
  return AuthToken()
    ..tokenType = json['token_type'] as String
    ..expiresIn = json['expires_in'] as int
    ..localCreateDate = json['localCreateDate'] == null
        ? null
        : DateTime.parse(json['localCreateDate'] as String)
    ..accessToken = json['access_token'] as String
    ..refreshToken = json['refresh_token'] as String
    ..grantType = json['grantType'] as String;
}

Map<String, dynamic> _$AuthTokenToJson(AuthToken instance) => <String, dynamic>{
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'localCreateDate': instance.localCreateDate?.toIso8601String(),
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'grantType': instance.grantType
    };
