/*
 * user_model.g.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      passsword: json['passsword'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      countryCode: json['countryCode'] as String,
      phonenumber: json['phonenumber'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      bagId: json['bagId'] as String,
      wishlistId: json['wishlistId'] as String,
      personalShopperId: json['personalShopperId'] as int,
      receiveNewsletters: json['receiveNewsletters'] as bool,
      expiryDate: DateTime.parse(json['expiryDate'] as String))
    ..benefits = (json['benefits'] as List).map((e) => BenefitModel.fromJson(e as Map<String, dynamic>)).toList();
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'passsword': instance.passsword,
      'name': instance.name,
      'email': instance.email,
      'countryCode': instance.countryCode,
      'phonenumber': instance.phonenumber,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'gender': instance.gender,
      'bagId': instance.bagId,
      'wishlistId': instance.wishlistId,
      'personalShopperId': instance.personalShopperId,
      'receiveNewsletters': instance.receiveNewsletters,
      'expiryDate': instance.expiryDate.toIso8601String(),
      'benefits': instance.benefits
    };
