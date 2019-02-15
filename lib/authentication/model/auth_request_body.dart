/*
 * auth_request_body.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/9/19 2:22 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:json_annotation/json_annotation.dart';
import '../authentication.dart';

part 'auth_request_body.g.dart';

@JsonSerializable(nullable: true)
class AuthRequestBody {
  String get client_id => Authentication.instance.AuthCredentials.apiClientID;
  String get client_secret => Authentication.instance.AuthCredentials.apiClientSecret;

  @JsonKey(name: "grant_type")
  final String grantType;
  final String scope;

  final String username;
  final String password;
  @JsonKey(name: "refresh_token")
  final String refreshToken;

  /// Request client auth token with guest user id.
  final int guestUserId;

  /// Request auth token with social account like WeChat, Facebook and so on.
  final String assertion;
  final String openid;

  /// Indicates if need bind Farfetch account with WeChat. If `ff_token` is not empty, it means need binding.
  @JsonKey(name: "ff_token")
  final String ffToken;

  /// Revoke auth token with below fields.
  final String token;
  @JsonKey(name: "token_type_hint")
  final String tokenTypeHint;

  factory AuthRequestBody.fromJson(Map<String, dynamic> json) => _$AuthRequestBodyFromJson(json);
  Map<String, dynamic> toJson() => _$AuthRequestBodyToJson(this);

  Map<String, dynamic> get dictionaryRepresentation => toJson();

  const AuthRequestBody({
    this.grantType,
    this.scope,
    this.username,
    this.password,
    this.refreshToken,
    this.guestUserId,
    this.assertion,
    this.openid,
    this.ffToken,
    this.token,
    this.tokenTypeHint,
  });
}
