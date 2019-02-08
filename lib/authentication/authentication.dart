/*
 * authentication.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'package:flutter_panda_service/authentication/auth_credentials_protocol.dart';
import 'package:flutter_panda_service/preferences/identifiable_protocol.dart';
import 'package:flutter_panda_service/preferences/key_value_store_user.dart';

import 'auth_token.dart';

class GrantType extends EnumType<int, String> {
  /// Need clientID, clientSecret and guest userID on demand
  static const int clientCredentials = 0;

  /// Need clientID, clientSecret, username and password (Full name is **resourceOwnerPasswordCredentials**)
  static const int passwordCredentials = clientCredentials + 1;

  /// Need clientID, clientSecret, username, password and wechat token
  static const int wechatCredentials = passwordCredentials + 1;

  /// Need clientID, clientSecret and refresh token
  static const int refreshToken = wechatCredentials + 1;

  const GrantType(int typeValue, String rawValue) : super(typeValue, rawValue);

  static const GrantType ClientCredentials = const GrantType(GrantType.clientCredentials, "client_credentials");
  static const GrantType PasswordCredentials = const GrantType(GrantType.passwordCredentials, "password");
  static const GrantType WechatCredentials = const GrantType(GrantType.wechatCredentials, "WeChat");
  static const GrantType RefreshToken = const GrantType(GrantType.refreshToken, "refresh_token");

  /// This field need to pass when request auth token according to diffrent grant type
  String scope() {
    switch (this.typeValue) {
      case GrantType.clientCredentials:
        return "api fabs smsverification";

      case GrantType.passwordCredentials:
      case GrantType.wechatCredentials:
      case GrantType.refreshToken:
        return "api offline_access fabs openid";
    }
    return "";
  }

  String toJson() => this.rawValue;

  factory GrantType.fromJson(String value) {
    switch (value) {
      case "client_credentials":
        return GrantType.ClientCredentials;
      case "password":
        return GrantType.PasswordCredentials;
      case "Wechat":
        return GrantType.WechatCredentials;
      case "refresh_token":
        return GrantType.RefreshToken;
      default:
        return null;
    }
  }
}

class Authentication {
  Authentication._internal();

  /// :~~ singleton helpers
  factory Authentication() => _getInstance();
  static Authentication _instance;
  static Authentication instance = _getInstance();

  static Authentication _getInstance() {
    if (_instance == null) {
      _instance = new Authentication._internal();
      _instance.fetchPersistedAuthTokenIfHave();
    }
    return _instance;
  }

  /// end of singleton ~~:

  static void setup(AuthCredentialsProtocol authCredentials) => _getInstance()._authCredentials = authCredentials;

  AuthTokenWrapper authToken;
  AuthCredentialsProtocol _authCredentials;

  AuthCredentialsProtocol get authCredentials => _authCredentials;

  set authCredentials(AuthCredentialsProtocol authCredentials) {
    _authCredentials = authCredentials;
  }

  Identifiable keyValueStore = KeyValueStoreUser();

  // helpers

  void fetchPersistedAuthTokenIfHave() {}
}
