/*
 * authentication.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:convert';

import 'package:flutter_panda_service/authentication/auth_error.dart';
import 'package:flutter_panda_service/restful_service/constants/R_endpoints.dart';
import 'package:flutter_panda_service/restful_service/error.dart';
import 'package:flutter_panda_service/restful_service/http_network.dart';
import 'package:meta/meta.dart';
import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import 'model/auth_request_body.dart';
import '../business_service/service_comon.dart';
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
  static const GrantType WechatCredentials = const GrantType(WECHATCREDENTIALS, "WeChat");
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

  AuthToken authToken = AuthToken();
  Identifiable keyValueStore = KeyValueStoreUser();

  AuthCredentialsProtocol _authCredentials;
  AuthCredentialsProtocol get authCredentials => _authCredentials;
  set authCredentials(AuthCredentialsProtocol authCredentials) {
    _authCredentials = authCredentials;
  }

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

  void requestTokenByClientCredentials(int guestId, ServiceEntityCompletion<AuthToken> completion) {
    const GrantType grantType = GrantType.ClientCredentials;
    AuthRequestBody requestBody =
        AuthRequestBody(grantType: grantType.rawValue, scope: grantType.scope(), guestUserId: guestId);
    this._requestAuthToken(body: requestBody, completion: completion);
  }

  void requestTokenByPasswordCredentials(
      String username, String password, ServiceEntityCompletion<AuthToken> completion,
      [bool isPersistence = true]) {
    const GrantType grantType = GrantType.PasswordCredentials;
    AuthRequestBody requestBody = AuthRequestBody(
        grantType: grantType.rawValue, scope: grantType.scope(), username: username, password: password);
    this._requestAuthToken(body: requestBody, completion: completion, isPersistence: isPersistence);
  }

  void requestTokenByPasswordCredentialsIgnoreCache(
      String username, String password, ServiceEntityCompletion<AuthToken> completion) {
    const GrantType grantType = GrantType.PasswordCredentials;
    AuthRequestBody requestBody = AuthRequestBody(
        grantType: grantType.rawValue, scope: grantType.scope(), username: username, password: password);
    this._requestAuthToken(body: requestBody, completion: completion, bypassCache: true);
  }

  void requestTokenByWechatCredentials(String wechatToken, String openID, ServiceEntityCompletion<AuthToken> completion,
      [String accessToken]) {
    const GrantType grantType = GrantType.WechatCredentials;
    AuthRequestBody requestBody = AuthRequestBody(
        grantType: grantType.rawValue,
        scope: grantType.scope(),
        assertion: wechatToken,
        openid: openID,
        ffToken: accessToken);
    this._requestAuthToken(body: requestBody, completion: completion);
  }

  void requestTokenIfNeeded(ServiceEntityCompletion<AuthToken> completion) {
    if (this.authToken == null) {
      this._requestNewAuthToken(completion: completion);
      return;
    }

    switch (this.authToken.state) {
      case AuthTokenState.valid:
        completion(this.authToken, null, null);
        break;

      case AuthTokenState.needRefresh:
        this._refreshCurrentToken(completion: completion);
        break;

      case AuthTokenState.invalid:
        this._requestNewAuthToken(completion: completion);
        break;
    }
  }

  void revokeCurrentToken(ServiceCompletion completion) {
    Future(() => null).then((_) {
      if (this.authToken == null) {
        completion(null, null);
        return;
      }

      String token = this.authToken.token.refreshToken ?? this.authToken.token.accessToken;
      String tokenHint =
          this.authToken.hasRefreshToken ? TypeHint.refreshToken.rawValue : TypeHint.accessToken.rawValue;
      AuthRequestBody body = AuthRequestBody(token: token, tokenTypeHint: tokenHint);
      RestfulServiceManager.post<dynamic>(
          endpoint: EndpointCollection.tokenRevoke,
          body: body.dictionaryRepresentation,
          contentType: HTTPContentType.formURLEncoded,
          completion: (dynamic model, response, err) {
            this.deleteAuthToken();

            // TODO: think about how to broadcast the notification. self.postDidRevokeAuthTokenNotification()

            completion(response, err);
          });
    });
  }

  void deleteCurrentAuthToken() {
    Future(() => null).then((_) {
      this.deleteAuthToken();
    });
  }

  // private helpers

  /// // If auth token is granted by password credentials and it is expired, we can call this method for refreshing.
  void _refreshCurrentToken({@required ServiceEntityCompletion<AuthToken> completion}) {
    const GrantType grantType = GrantType.RefreshToken;
    AuthRequestBody body = AuthRequestBody(
        grantType: grantType.rawValue, scope: grantType.scope(), refreshToken: this.authToken.hasRefreshToken);

    this._requestAuthToken(
      body: body,
      completion: (token, response, err) {
        if (err == null) {
          completion(authToken, response, null);
          return;
        }

        // We distinguish between a timeout error from other random errors
        // Timeout in theory means that the refresh token is still valid
        // Always retry if refresh token timeout
        if (err == RestfulError.timeout()) {
          this._refreshCurrentToken(completion: completion);
          return;
        }

        // Refresh token can return 401, which is treated as an error which actually corresponds that refreshToken is no longer valid.
        // In either case, we should request another token and go on with life.
        this._requestNewAuthToken(completion: (token, response, err) {
          if (err != null && response.originalResponse.statusCode == 401) {
            this.deleteAuthToken();
            // TODO: think about how to broadcast the notification. self.postAuthTokenWasInvalidNotification()
          }

          completion(this.authToken, response, err);
        });
      },
    );
  }

  void _requestNewAuthToken({@required ServiceEntityCompletion<AuthToken> completion}) {
    GrantType grantType = this.authToken != null ? this.authToken.grantType : GrantType.ClientCredentials;

    if (grantType == GrantType.PasswordCredentials || grantType == GrantType.WechatCredentials) {
      if (KeyChainHelper().username != null && KeyChainHelper().password != null) {
        this.requestTokenByPasswordCredentialsIgnoreCache(
            KeyChainHelper().username, KeyChainHelper().password, completion);
      } else {
        completion(null, null, AuthError.InvalidGrant);
      }
    } else {
      this.requestTokenByClientCredentials(KeyValueStoreUser().guestID, completion);
    }
  }

  void _requestAuthToken(
      {@required AuthRequestBody body,
      ServiceEntityCompletion<AuthToken> completion,
      bool bypassCache = false,
      bool isPersistence = false}) {
    Future(() => null).then((_) {
      if (bypassCache == false &&
          this.authToken != null &&
          this.authToken.grantType().rawValue == body.grantType &&
          this.authToken.state == AuthTokenState.valid) {
        // TODO: implement the notification later ->  self.postDidAuthenticateTokenNotification()
        completion(this.authToken, null, null);
        return;
      }

      RestfulServiceManager.service.request(
          endpoint: EndpointCollection.tokenRequest,
          body: body.dictionaryRepresentation,
          contentType: HTTPContentType.formURLEncoded,
          completion: (authToken, response, error) {
            if (this.authToken == null) {
              this.deleteAuthToken();

              if (response.data == null) {
                completion(this.authToken, response, error);
                return;
              }

              try {
                String errorStr = utf8.decode(response.data);
                Map<String, dynamic> errorJson = jsonDecode(errorStr);
                AuthErrorResponse errorResp = AuthErrorResponse.fromJson(errorJson);

                var respError;
                if (errorResp.errorDescription != null) {
                  respError = AuthError.fromRawValue(errorResp.errorDescription);
                } else {
                  respError = AuthError.fromRawValue(errorResp.error);
                }
                completion(this.authToken, response, respError);
              } catch (except) {
                throw "AuthErrorResponse decode error: $error";
              }
              return;
            }

            AuthToken newToken = this.authToken;
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
          });
    });
  }
}
