// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthErrorResponse _$AuthErrorResponseFromJson(Map<String, dynamic> json) {
  return AuthErrorResponse(
      error: json['error'] as String,
      errorDescription: json['error_description'] as String);
}

Map<String, dynamic> _$AuthErrorResponseToJson(AuthErrorResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'error_description': instance.errorDescription
    };
