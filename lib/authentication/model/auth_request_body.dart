/*
 * auth_request_body.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/9/19 2:22 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_service/authentication/authentication.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class AuthRequestBody {
  String get client_id => Authentication.instance.authCredentials.apiClientID;
  String get client_secret => Authentication.instance.authCredentials.apiClientSecret;

  final String grant_type;
  final String scope;

  final String username;
  final String password;
  final String refresh_token;

  /// Request client auth token with guest user id.
  final int guestUserId;

  /// Request auth token with social account like WeChat, Facebook and so on.
  final String assertion;
  final String openid;

  /// Indicates if need bind Farfetch account with WeChat. If `ff_token` is not empty, it means need binding.
  final String ff_token;

  /// Revoke auth token with below fields.
  final String token;
  final String token_type_hint;

  const AuthRequestBody({
    this.grant_type,
    this.scope,
    this.username,
    this.password,
    this.refresh_token,
    this.guestUserId,
    this.assertion,
    this.openid,
    this.ff_token,
    this.token,
    this.token_type_hint,
  });
}
