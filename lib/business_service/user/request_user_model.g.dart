// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestUserModel _$RequestUserModelFromJson(Map<String, dynamic> json) {
  return RequestUserModel(json['email'] as String,
      json['phoneNumber'] as String, json['countryCode'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      name: json['name'] as String);
}

Map<String, dynamic> _$RequestUserModelToJson(RequestUserModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'countryCode': instance.countryCode
    };

RequestGuestModel _$RequestGuestModelFromJson(Map<String, dynamic> json) {
  return RequestGuestModel(
      countryCode: json['countryCode'] as String,
      ip: json['ip'] as String,
      externalId: json['externalId'] as String,
      friendId: json['friendId'] as String);
}

Map<String, dynamic> _$RequestGuestModelToJson(RequestGuestModel instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'ip': instance.ip,
      'externalId': instance.externalId,
      'friendId': instance.friendId
    };

ChangePasswordModel _$ChangePasswordModelFromJson(Map<String, dynamic> json) {
  return ChangePasswordModel(
      username: json['username'] as String,
      oldPassword: json['oldPassword'] as String,
      newPassword: json['newPassword'] as String);
}

Map<String, dynamic> _$ChangePasswordModelToJson(
        ChangePasswordModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'oldPassword': instance.oldPassword,
      'newPassword': instance.newPassword
    };
