/*
 * error_model.g.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorModel _$ErrorModelFromJson(Map<String, dynamic> json) {
  return ErrorModel(code: json['Code'] as int, message: json['Message'] as String, developerMessage: json['DeveloperMessage'] as String);
}

Map<String, dynamic> _$ErrorModelToJson(ErrorModel instance) => <String, dynamic>{'Code': instance.code, 'Message': instance.message, 'DeveloperMessage': instance.developerMessage};

ErrorResponseBody _$ErrorResponseBodyFromJson(Map<String, dynamic> json) {
  return ErrorResponseBody(errors: (json['Errors'] as List)?.map((e) => e == null ? null : ErrorModel.fromJson(e as Map<String, dynamic>))?.toList());
}

Map<String, dynamic> _$ErrorResponseBodyToJson(ErrorResponseBody instance) => <String, dynamic>{'Errors': instance.errors};
