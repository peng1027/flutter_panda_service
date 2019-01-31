/*
 *
 * JSONWebToken.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/7/19 10:01 PM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import 'AuthToken.dart';

part 'JSONWebToken.g.dart';

class IdentityProvider {
  /// Farfetch account login
  String get farfetch => "idsrv";

  /// Wechat login
  String get wechat => "WeChat";
}

@JsonSerializable(nullable: true)
class ClaimsSet {
  @JsonKey(name: "scope", nullable: true, fromJson: _scopeFromJson)
  String scope;
  @JsonKey(name: "exp", nullable: true)
  final int expireTime;
  @JsonKey(name: "nbf", nullable: true)
  final int notBefore;
  @JsonKey(name: "auth_time", nullable: true)
  final int authTime;
  @JsonKey(name: "client_id", nullable: true)
  final String clientID;
  @JsonKey(name: "client_uid", nullable: true)
  final String clientUID;
  @JsonKey(name: "client_guest", nullable: true)
  final String guestID;
  @JsonKey(name: "client_tenantId", nullable: true)
  final String tenantID;
  @JsonKey(name: "newuser", nullable: true)
  final String newUser;
  @JsonKey(name: "idp", nullable: true)
  final String identityProvider;

  ClaimsSet({
    this.scope,
    this.expireTime,
    this.notBefore,
    this.authTime,
    this.clientID,
    this.clientUID,
    this.guestID,
    this.tenantID,
    this.newUser,
    this.identityProvider,
  });

  factory ClaimsSet.fromJson(Map<String, dynamic> json) => _$ClaimsSetFromJson(json);
  Map<String, dynamic> toJson() => _$ClaimsSetToJson(this);

  static String _scopeFromJson(dynamic obj) {
    if (obj is List<String>) {
      var tmp = obj.map((e) => e)?.toList();
      return tmp.join(AuthToken.scopeSeparator);
    } else if (obj is String) {
      return obj;
    } else {
      return "";
    }
  }
}

class JSONWebToken {
  String get scope => this._claimset.scope;
  int get expireTime => this._claimset.expireTime;
  int get notBefore => this._claimset.notBefore;
  int get authTime => this._claimset.authTime;
  int get guestID => this._claimset.guestID != null ? (int.parse(this._claimset.guestID)) : null;
  String get clientID => this._claimset.clientID;
  String get clientUID => this._claimset.clientUID;
  String get tenantID => this._claimset.tenantID;
  String get newUser => this._claimset.newUser;
  String get identityProvider => this._claimset.identityProvider;

  ClaimsSet _claimset;

  Map<String, dynamic> toJson() => this._claimset.toJson();
  factory JSONWebToken.fromJson(Map<String, dynamic> json) => JSONWebToken._internal(ClaimsSet.fromJson(json));

  JSONWebToken._internal(this._claimset);

  factory JSONWebToken(String accessToken) {
    JSONWebToken result;

    List<String> components = accessToken.split(".");
    if (components.length > 1) {
      Uint8List data = Base64Codec().decode(paddingBase64(components[1]));
      String jsonStr = Utf8Decoder().convert(data);
      Map<String, dynamic> jsonData = json.decode(jsonStr);
      JSONWebToken._internal(ClaimsSet.fromJson(jsonData));
    }

    return result;
  }
}
