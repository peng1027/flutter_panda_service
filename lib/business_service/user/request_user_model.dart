/*
 * request_user_model.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_service/restful_service/serializable_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_user_model.g.dart';

@JsonSerializable(nullable: false)
class RequestUserModel implements SerializableModelProtocol {
  final String username;
  final String password;
  final String name;
  final String email;
  final String phoneNumber;
  final String countryCode;

  RequestUserModel(this.email, this.phoneNumber, this.countryCode, {this.username, this.password, this.name});

  factory RequestUserModel.fromJson(Map<String, dynamic> json) => _$RequestUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$RequestUserModelToJson(this);
}

@JsonSerializable(nullable: false)
class RequestGuestModel implements SerializableModelProtocol {
  final String countryCode;
  final String ip;
  final String externalId;
  final String friendId;

  RequestGuestModel({this.countryCode, this.ip, this.externalId, this.friendId});

  factory RequestGuestModel.fromJson(Map<String, dynamic> json) => _$RequestGuestModelFromJson(json);
  Map<String, dynamic> toJson() => _$RequestGuestModelToJson(this);
}

@JsonSerializable(nullable: false)
class ChangePasswordModel implements SerializableModelProtocol {
  final String username;
  final String oldPassword;
  final String newPassword;

  ChangePasswordModel({this.username, this.oldPassword, this.newPassword});

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) => _$ChangePasswordModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChangePasswordModelToJson(this);
}
