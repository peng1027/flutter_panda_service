/*
 *
 * AuthToken.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/3/19 12:39 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:convert';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'JSONWebToken.dart';

import 'Authentication.dart';

part 'AuthToken.g.dart';

class TypeHint extends EnumValue<String> {
  TypeHint(String value) : super(rawValue: value);

  static TypeHint accessToken() => TypeHint("access_token");
  static TypeHint refreshToken() => TypeHint("refresh_token");
}

@JsonSerializable(nullable: true)
class AuthToken {
  AuthToken();

  @JsonKey(name: "token_type")
  String tokenType;

  @JsonKey(name: "expires_in")
  int expiresIn;

  DateTime get localCreateDate => _localCreateDate;
  set localCreateDate(DateTime newValue) => _localCreateDate = newValue ?? DateTime.now();

  @JsonKey(name: "access_token")
  String get accessToken => _accessToken;
  set accessToken(String newValue) {
    _accessToken = newValue;

    jwtToken = new JSONWebToken(_accessToken);

    _scope = jwtToken.scope;
    createDate = DateTime.fromMillisecondsSinceEpoch(jwtToken.notBefore * 1000);
    expireDate = DateTime.fromMillisecondsSinceEpoch(jwtToken.expireTime * 1000);

    if (createDate != null && expireDate == null) {
      expireDate = createDate.add(Duration(seconds: expiresIn * 1000));
    }
    localExpireDate = localCreateDate.add(Duration(seconds: expiresIn * 1000));
  }

  @JsonKey(name: "refresh_token")
  String refreshToken;

  String get scope => _scope;

  String get grantType => _grantType.rawValue;
  set grantType(String newValue) {
    _grantType = GrantType.fromJson(newValue);
  }

  /// json serialization functions
  ///
  factory AuthToken.fromJson(Map<String, dynamic> json) => _$AuthTokenFromJson(json);
  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);

  String jsonRepresentation() {
    Map<String, dynamic> json = this.toJson();
    return jsonEncode(json);
  }

  /// json ignored properties.

  @JsonKey(ignore: true)
  DateTime _localCreateDate;

  @JsonKey(ignore: true)
  JSONWebToken jwtToken;

  @JsonKey(ignore: true)
  DateTime createDate;

  @JsonKey(ignore: true)
  DateTime expireDate;

  @JsonKey(ignore: true)
  DateTime localExpireDate;

  @JsonKey(ignore: true)
  static const scopeSeparator = " ";

  String _accessToken;
  String _scope;
  GrantType _grantType = GrantType.getClientCredentials();
}

enum AuthTokenState { valid, needRefresh, invalid }

class AuthTokenWrapper {
  AuthToken _authToken;

  bool get isUserToken => _authToken.refreshToken != null;
  String get tenantID => _authToken.jwtToken.tenantID;
  String get clientUID => _authToken.jwtToken.clientUID;
  int get guestID => _authToken.jwtToken.guestID;

  DateTime get authDate {
    if (_authToken.jwtToken.authTime == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(_authToken.jwtToken.authTime * 1000);
  }

  /// json serialization methods.
  void fromJson(Map<String, dynamic> json) => _authToken = AuthToken.fromJson(json);
  Map<String, dynamic> toJson() => _authToken.toJson();

  AuthTokenState get state {
    if (_isSameScope) return AuthTokenState.invalid;
    return _isValid ? AuthTokenState.valid : (hasRefreshToken ? AuthTokenState.needRefresh : AuthTokenState.invalid);
  }

  get hasRefreshToken => _authToken.refreshToken != null;

  /// check whether there is the same scope between auth token and its grant type
  get _isSameScope {
    if (_authToken == null) return false;
    if (_authToken.scope == null) return false;

    List<String> authTokenPart = _authToken.grantType.split(AuthToken.scopeSeparator);
    authTokenPart = authTokenPart
        .where((eachPart) => !_authToken.scope.split(AuthToken.scopeSeparator).contains(eachPart))
        .toList();

    return authTokenPart.isEmpty;
  }

  /// auth token had been expired or not?
  get _isExpired {
    DateTime newExpiredDate;

    if (_authToken.expireDate != null) {
      Duration deviation = _authToken.localExpireDate.difference(_authToken.expireDate);
      newExpiredDate = _authToken.expireDate.add(deviation);
    } else {
      newExpiredDate = _authToken.localExpireDate;
    }

    newExpiredDate.add(Duration(minutes: -1));
    return DateTime.now().isAfter(newExpiredDate);
  }

  get _isValid {
    if (!hasRefreshToken &&
        _authToken._grantType == GrantType.getClientCredentials() &&
        Authentication.instance.keyValueStore.guestID != null) {
      return Authentication.instance.keyValueStore.guestID == this.guestID ? _isExpired : false;
    } else {
      return _isExpired;
    }
  }
}
