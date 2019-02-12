// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_web_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimsSet _$ClaimsSetFromJson(Map<String, dynamic> json) {
  return ClaimsSet(
      scope: json['scope'] == null
          ? null
          : ClaimsSet._scopeFromJson(json['scope']),
      expireTime: json['exp'] as int,
      notBefore: json['nbf'] as int,
      authTime: json['auth_time'] as int,
      clientID: json['client_id'] as String,
      clientUID: json['client_uid'] as String,
      guestID: json['client_guest'] as String,
      tenantID: json['client_tenantId'] as String,
      newUser: json['newuser'] as String,
      identityProvider: json['idp'] as String);
}

Map<String, dynamic> _$ClaimsSetToJson(ClaimsSet instance) => <String, dynamic>{
      'scope': instance.scope,
      'exp': instance.expireTime,
      'nbf': instance.notBefore,
      'auth_time': instance.authTime,
      'client_id': instance.clientID,
      'client_uid': instance.clientUID,
      'client_guest': instance.guestID,
      'client_tenantId': instance.tenantID,
      'newuser': instance.newUser,
      'idp': instance.identityProvider
    };
