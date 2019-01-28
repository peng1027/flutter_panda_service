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
      expiryDate: DateTime.parse(json['expiryDate'] as String));
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
      'expiryDate': instance.expiryDate.toIso8601String()
    };

BenefitModel _$BenefitModelFromJson(Map<String, dynamic> json) {
  return BenefitModel(
      id: json['id'] as String,
      code: json['code'] as String,
      isActive: json['isActive'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>);
}

Map<String, dynamic> _$BenefitModelToJson(BenefitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'isActive': instance.isActive,
      'metadata': instance.metadata
    };
