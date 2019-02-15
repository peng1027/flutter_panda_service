/*
 * authentication.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:async';
import 'dart:convert';
import 'package:flutter_panda_service/restful_service/http_response.dart';
import 'package:meta/meta.dart';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import 'model/auth_request_body.dart';
import '../authentication/auth_error.dart';
import '../restful_service/constants/R_endpoints.dart';
import '../restful_service/http_error.dart';
import '../restful_service/http_network.dart';
import '../restful_service/service_result.dart';
import '../restful_service/service_manager.dart';
import '../authentication/auth_credentials_protocol.dart';
import '../preferences/identifiable_protocol.dart';
import '../preferences/key_value_store_user.dart';

import 'auth_token.dart';

class GrantType extends EnumType<int, String> {
  /// Need clientID, clientSecret and guest userID on demand
  static const int CLIENTCREDENTIALS = 0;

  /// Need clientID, clientSecret, username and password (Full name is **resourceOwnerPasswordCredentials**)
  static const int PASSWORDCREDENTIALS = CLIENTCREDENTIALS + 1;

  /// Need clientID, clientSecret, username, password and wechat token
  static const int WECHATCREDENTIALS = PASSWORDCREDENTIALS + 1;

  /// Need clientID, clientSecret and refresh token
  static const int REFRESHTOKEN = WECHATCREDENTIALS + 1;

  const GrantType(int typeValue, String rawValue) : super(typeValue, rawValue);

  static const GrantType ClientCredentials = const GrantType(CLIENTCREDENTIALS, "client_credentials");
  static const GrantType PasswordCredentials = const GrantType(PASSWORDCREDENTIALS, "password");
  static const GrantType WeChatCredentials = const GrantType(WECHATCREDENTIALS, "WeChat");
  static const GrantType RefreshToken = const GrantType(REFRESHTOKEN, "refresh_token");

  /// This field need to pass when request auth token according to different grant type
  String scope() {
    switch (this.typeValue) {
      case GrantType.CLIENTCREDENTIALS:
        return "api fabs smsverification";

      case GrantType.PASSWORDCREDENTIALS:
      case GrantType.WECHATCREDENTIALS:
      case GrantType.REFRESHTOKEN:
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
        return GrantType.WeChatCredentials;
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

  AuthToken authToken = AuthToken();
  Identifiable keyValueStore = KeyValueStoreUser();

  AuthCredentialsProtocol _authCredentials;
  AuthCredentialsProtocol get AuthCredentials => _authCredentials;
  set AuthCredentials(AuthCredentialsProtocol authCredentials) => _authCredentials = authCredentials;

  // authentic token helpers

  void persistAuthToken(AuthToken authToken) {
    this.authToken = authToken;
    KeyChainHelper().persistAuthToken(this.authToken.jsonRepresentation());
  }

  void deleteAuthToken() {
    this.authToken = null;
    KeyChainHelper().deletePersistedAuthToken();
  }

  void fetchPersistedAuthTokenIfHave() {
    String _authToken = KeyChainHelper().authToken;
    if (_authToken == null) {
      return;
    }

    Map<String, String> jsonObj = JsonCodec().decode(_authToken);
    this.authToken.fromJson(jsonObj);
    this.authToken.setGrantType(GrantType.PasswordCredentials);
  }

  // network request helpers

  Future<ServiceEntityResultModel<AuthToken>> requestTokenByClientCredentials(int guestId) async {
    const GrantType grantType = GrantType.ClientCredentials;
    AuthRequestBody requestBody = AuthRequestBody(grantType: grantType.rawValue, scope: grantType.scope(), guestUserId: guestId);
    return await this._requestAuthToken(body: requestBody);
  }

  Future<ServiceEntityResultModel<AuthToken>> requestTokenByPasswordCredentials(String username, String password, [bool isPersistence = true]) async {
    const GrantType grantType = GrantType.PasswordCredentials;
    AuthRequestBody requestBody = AuthRequestBody(grantType: grantType.rawValue, scope: grantType.scope(), username: username, password: password);
    return await this._requestAuthToken(body: requestBody, isPersistence: isPersistence);
  }

  Future<ServiceEntityResultModel<AuthToken>> requestTokenByPasswordCredentialsIgnoreCache(String username, String password) async {
    const GrantType grantType = GrantType.PasswordCredentials;
    AuthRequestBody requestBody = AuthRequestBody(grantType: grantType.rawValue, scope: grantType.scope(), username: username, password: password);
    return await this._requestAuthToken(body: requestBody, bypassCache: true);
  }

  Future<ServiceEntityResultModel<AuthToken>> requestTokenByWeChatCredentials(String weChatToken, String openID, [String accessToken]) async {
    const GrantType grantType = GrantType.WeChatCredentials;
    AuthRequestBody requestBody = AuthRequestBody(grantType: grantType.rawValue, scope: grantType.scope(), assertion: weChatToken, openid: openID, ffToken: accessToken);
    return await this._requestAuthToken(body: requestBody);
  }

  Future<ServiceEntityResultModel<AuthToken>> refreshTokenIfNeeded() async {
    if (this.authToken == null) {
      return this._requestNewAuthToken();
    }

    switch (this.authToken.state) {
      case AuthTokenState.valid:
        Completer completer = new Completer();
        completer.complete(() => ServiceEntityResultModel(data: this.authToken));
        return completer.future;
        break;

      case AuthTokenState.needRefresh:
        return this._refreshCurrentToken();
        break;

      case AuthTokenState.invalid:
        return this._requestNewAuthToken();
        break;

      default:
        // default, as valid authenticate token
        Completer completer = new Completer();
        completer.complete(() => ServiceEntityResultModel(data: this.authToken));
        return completer.future;
    }
  }

  Future<ServiceEntityResultModel<Null>> revokeCurrentToken() async {
    if (this.authToken == null) {
      Completer completer = new Completer();
      completer.complete(() => ServiceEntityResultModel());
      return completer.future;
    }

    String token = this.authToken.token.refreshToken ?? this.authToken.token.accessToken;
    String tokenHint = this.authToken.hasRefreshToken ? TypeHint.refreshToken.rawValue : TypeHint.accessToken.rawValue;
    AuthRequestBody body = AuthRequestBody(token: token, tokenTypeHint: tokenHint);
    return await RestfulServiceManager.post<ServiceEntityResultModel<Null>>(
      endpoint: EndpointCollection.tokenRevoke,
      body: body.dictionaryRepresentation,
      contentType: HTTPContentType.formURLEncoded,
    ).then((serviceResult) {
      this.deleteAuthToken();

      // TODO: think about how to broadcast the notification. self.postDidRevokeAuthTokenNotification()

      return ServiceEntityResultModel(response: serviceResult.response, error: serviceResult.error);
    });
  }

  void deleteCurrentAuthToken() {
    Future(() => null).then((_) {
      this.deleteAuthToken();
    });
  }

  // extension helpers

  // private helpers

  /// // If auth token is granted by password credentials and it is expired, we can call this method for refreshing.
  Future<ServiceEntityResultModel<AuthToken>> _refreshCurrentToken() async {
    const GrantType grantType = GrantType.RefreshToken;
    AuthRequestBody body = AuthRequestBody(grantType: grantType.rawValue, scope: grantType.scope(), refreshToken: this.authToken.hasRefreshToken);

    return await this._requestAuthToken(body: body).then((result) {
      AuthToken token = result.data;
      HttpResponse response = result.response;
      HttpError error = result.error;

      if (error == null) {
        return ServiceEntityResultModel(data: token, response: response);
      }

      // We distinguish between a timeout error from other random errors
      // Timeout in theory means that the refresh token is still valid
      // Always retry if refresh token timeout
      if (error == HttpError.timeout()) {
        return this._refreshCurrentToken();
      }

      // Refresh token can return 401, which is treated as an error which actually corresponds that refreshToken is no longer valid.
      // In either case, we should request another token and go on with life.
      return this._requestNewAuthToken().then((newResult) {
        if (newResult.error != null && newResult.response.originalResponse.statusCode == 401) {
          this.deleteAuthToken();
          // TODO: think about how to broadcast the notification. self.postAuthTokenWasInvalidNotification()
        }
        return ServiceEntityResultModel(data: this.authToken, response: response);
      });
    });
  }

  Future<ServiceEntityResultModel<AuthToken>> _requestNewAuthToken() async {
    GrantType grantType = this.authToken != null ? this.authToken.grantType : GrantType.ClientCredentials;

    if (grantType == GrantType.PasswordCredentials || grantType == GrantType.WeChatCredentials) {
      if (KeyChainHelper().username != null && KeyChainHelper().password != null) {
        return await this.requestTokenByPasswordCredentialsIgnoreCache(KeyChainHelper().username, KeyChainHelper().password);
      } else {
        Completer completer = Completer();
        completer.complete(new ServiceEntityResultModel<AuthToken>(error: AuthError.InvalidGrant));
        return completer.future;
      }
    } else {
      return await this.requestTokenByClientCredentials(KeyValueStoreUser().guestID);
    }
  }

  Future<AuthToken> _requestAuthToken({
    @required AuthRequestBody body,
    bool bypassCache = false,
    bool isPersistence = false,
  }) async {
    if (bypassCache == false && this.authToken != null && this.authToken.grantType().rawValue == body.grantType && this.authToken.state == AuthTokenState.valid) {
      // TODO: implement the notification later ->  self.postDidAuthenticateTokenNotification()
      return this.authToken;
    }

    return await RestfulServiceManager.post(
      endpoint: EndpointCollection.tokenRequest,
      body: body.dictionaryRepresentation,
      contentType: HTTPContentType.formURLEncoded,
    ).then((serviceResult) {

      ServiceEntityResultModel model = serviceResult as ServiceEntityResultModel;

      AuthToken authToken = AuthToken()
      HttpResponse response = model.response;
      ErrorType error = model.error;
      authToken.fromJson(model.data as Map<String, dynamic>);

      if (authToken == null || authToken.jsonRepresentation().length == 0) {
        this.deleteAuthToken();

        if (response.data == null) {
          return null;
        }

        var respError;
        try {
          String errorStr = utf8.decode(response.data);
          Map<String, dynamic> errorJson = jsonDecode(errorStr);
          AuthErrorResponse errorResp = AuthErrorResponse.fromJson(errorJson);

          if (errorResp.errorDescription != null) {
            respError = AuthError.fromRawValue(errorResp.errorDescription);
          } else {
            respError = AuthError.fromRawValue(errorResp.error);
          }
        } catch (except) {
          throw "AuthErrorResponse decode error: $error";
        }

        return ServiceEntityResultModel(response: response, error: respError);
      }

      AuthToken newToken = authToken;
      if (body.grantType != null) {
        var newGrantType = GrantType.fromJson(body.grantType);
        if (newGrantType != null) {
          newToken.setGrantType(newGrantType);
        }
      }

      if (isPersistence) {
        if (newToken.hasRefreshToken) {
          this.persistAuthToken(newToken);
        } else {
          this.deleteAuthToken();
        }
      } else {
        this.authToken = newToken;
      }

      return ServiceEntityResultModel(data: newToken, response: response, error: error);
    });
  }
}
