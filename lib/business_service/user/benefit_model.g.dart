// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'benefit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
