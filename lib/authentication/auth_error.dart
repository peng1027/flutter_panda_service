/*
 * auth_error.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/15/19 12:23 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/common/enum_type.dart';
import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_error.g.dart';

class AuthErrorCode {
  static String get invalidRequest => "invalid_request";
  static String get invalidClient => "invalid_client";
  static String get invalidGrant => "invalid_grant";
  static String get invalidScope => "invalid_scope";
  static String get unauthorizedClient => "unauthorized_client";
  static String get unsupportedGrantType => "unsupported_grant_type";
  static String get wechatBindNeeded => "Merge needed, send valid Farfetch token";
  static String get wechatBindFailed => "Error adding the external login to the account";
  static String get wechatAlreadyBinded => "Provider id is already linked to an account.";
}

class AuthErrorDescription {
  static String get invalidUsernamePassword => "Invalid username or password.";
  static String get userDisabled => "User disabled.";
}

@JsonSerializable(nullable: false)
class AuthErrorResponse extends Error {
  final String error;

  @JsonKey(name: "error_description")
  final String errorDescription;

  AuthErrorResponse({this.error, this.errorDescription});

  factory AuthErrorResponse.fromJson(Map<String, dynamic> json) => _$AuthErrorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthErrorResponseToJson(this);
}

class AuthError extends EnumType<int, String> implements ErrorType {
  static int get invalidGrant => 0;
  static int get userDisabled => invalidGrant + 1;

  /// Input wrong username or password when login
  static int get invalidUsernamePassword => userDisabled + 1;

  /// When use social account like Wechat to login, if no Farfetch account is binded, need login existing account or register one first, then bind it.
  static int get wechatBindNeeded => invalidUsernamePassword + 1;
  static int get wechatBindFailed => wechatBindNeeded + 1;
  static int get wechatAlreadyBinded => wechatBindFailed + 1;

  const AuthError(int type, String value) : super(type, value);

  static AuthError fromRawValue(String value) {
    if (value == AuthErrorDescription.invalidUsernamePassword)
      return InvalidUsernamePassword;
    else if (value == AuthErrorDescription.userDisabled)
      return UserDisabled;
    else if (value == AuthErrorCode.wechatBindNeeded)
      return WechatBindNeeded;
    else if (value == AuthErrorCode.wechatAlreadyBinded)
      return WechatAlreadyBinded;
    else if (value.startsWith(AuthErrorCode.wechatBindFailed))
      return WechatBindFailed;
    else
      return InvalidGrant;
  }

  static AuthError get InvalidGrant => AuthError(invalidGrant, AuthErrorCode.invalidGrant);
  static AuthError get UserDisabled => AuthError(userDisabled, AuthErrorDescription.userDisabled);
  static AuthError get InvalidUsernamePassword => AuthError(invalidUsernamePassword, AuthErrorDescription.invalidUsernamePassword);
  static AuthError get WechatBindNeeded => AuthError(wechatBindNeeded, AuthErrorCode.wechatBindNeeded);
  static AuthError get WechatBindFailed => AuthError(wechatBindFailed, AuthErrorCode.wechatBindFailed);
  static AuthError get WechatAlreadyBinded => AuthError(wechatAlreadyBinded, AuthErrorCode.wechatAlreadyBinded);
}
