/*
 * authentication_ext.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/16/19 3:31 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:async';

import 'auth_token.dart';
import 'authentication.dart';

class AuthenticationExt {
  AuthenticationExt._internal();

  factory AuthenticationExt() => _getInstance();
  static AuthenticationExt _instance;
  static AuthenticationExt instance = _getInstance();

  static AuthenticationExt _getInstance() {
    if (_instance == null) {
      _instance = AuthenticationExt._internal();
      _instance._internalAuthen = Authentication();
    }
    return _instance;
  }

  Authentication _internalAuthen;

  Future<AuthToken> futureForRequestTokenByClientCredentials(int guestId) async {
    return await this._internalAuthen.requestTokenByClientCredentials(guestId).then((result) {
      if (result.data != null) {
        return result.data;
      } else {
        Completer completer = Completer();
        completer.completeError(result.error);
        return null;
      }
    });
  }

  Future<AuthToken> futureForRequestTokenByPasswordCredentials(String username, String password, [bool isPersistence = true]) async {
    return await this._internalAuthen.requestTokenByPasswordCredentials(username, password, isPersistence).then((result) {
      if (result.data != null) {
        return result.data;
      } else {
        Completer completer = Completer();
        completer.completeError(result.error);
        return null;
      }
    });
  }

  Future<AuthToken> futureForRequestTokenByWeChatCredentials(String accessToken, String weChatToken, String openId) async {
    return await this._internalAuthen.requestTokenByWeChatCredentials(weChatToken, openId, accessToken).then((result) {
      if (result.data != null) {
        return result.data;
      } else {
        Completer completer = Completer();
        completer.completeError(result.error);
        return null;
      }
    });
  }

  Future<AuthToken> futureForRequestTokenIfNeeded(bool needAuth) async {
    if (needAuth == false) return null;

    return await this._internalAuthen.refreshTokenIfNeeded().then((result) {
      if (result.error != null) {
        Completer completer = Completer();
        completer.completeError(result.error);
        return null;
      } else {
        return result.data;
      }
    });
  }

  Future<void> futureForRevokeCurrentToken() async {
    return this._internalAuthen.revokeCurrentToken().then((result) {
      Completer completer = Completer();
      if (result.error != null) {
        completer.completeError(result.error);
      } else {
        completer.complete();
      }
      return completer.future;
    });
  }
}
