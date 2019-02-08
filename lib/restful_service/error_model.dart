/*
 * error_model.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'error_model.g.dart';

@JsonSerializable(nullable: true)
class ErrorModel {
  @JsonKey(name: 'Code')
  final int code;
  @JsonKey(name: 'Message', nullable: true)
  final String message;
  @JsonKey(name: 'DeveloperMessage', nullable: true)
  final String developerMessage;

  ErrorModel({this.code, this.message, this.developerMessage});

  factory ErrorModel.fromJson(Map<String, dynamic> json) => _$ErrorModelFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}

@JsonSerializable(nullable: true)
class ErrorResponseBody {
  @JsonKey(name: 'Errors')
  final List<ErrorModel> errors;

  ErrorResponseBody({this.errors});

  factory ErrorResponseBody.fromJson(Map<String, dynamic> json) => _$ErrorResponseBodyFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResponseBodyToJson(this);
}
