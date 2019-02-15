/*
 * endpoints.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:core';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'package:sprintf/sprintf.dart';

import '../flutter_panda_service.dart' as globals;

class ApiType extends EnumType<int, String> {
  const ApiType(int type, String rawValue) : super(type, rawValue);

  static const int eCommerce = 0;
  static const int content = eCommerce + 1;
  static const int payment = content + 1;
  static const int almirCMS = payment + 1;
  static const int marketing = almirCMS + 1;
  static const int abTesting = marketing + 1;
  static const int authentication = abTesting + 1;
  static const int channelService = authentication + 1;

  static const ApiType ECommerce = const ApiType(ApiType.eCommerce, "eCommerce");
  static const ApiType Content = const ApiType(ApiType.content, "content");
  static const ApiType Payment = const ApiType(ApiType.payment, "payment");
  static const ApiType AlmirCMS = const ApiType(ApiType.almirCMS, "almirCMS");
  static const ApiType Marketing = const ApiType(ApiType.marketing, "marketing");
  static const ApiType AbTesting = const ApiType(ApiType.abTesting, "abTesting");
  static const ApiType Authentication = const ApiType(ApiType.authentication, "authentication");
  static const ApiType ChannelService = const ApiType(ApiType.channelService, "channelService");
}

class Domain extends EnumType<int, String> {
  static const int GLOBAL = 0;
  static const int PAYMENT = GLOBAL + 1;
  static const int AUTHENTICATION = PAYMENT + 1;
  static const int CHINA = AUTHENTICATION + 1;

  const Domain(int type, String rawValue) : super(type, rawValue);

  static const Domain global = const Domain(GLOBAL, "https://api.farfetch.net");
  static const Domain payment = const Domain(PAYMENT, "https://paymentsapi.farfetch.net");
  static const Domain authentication = const Domain(AUTHENTICATION, "https://api.farfetch.net/ext/auth");
  static const Domain china = const Domain(CHINA, "https://channel-service-panda.farfetch.net");
}

// Endpoint about base Endpoint URL settings
class Endpoint extends EnumType<int, String> {
  String _apiPath;
  set apiPath(String newValue) => _apiPath = newValue;

  Endpoint({int apiType, String apiPath}) : super(apiType, apiPath);

  String path() => ((_apiPath.matchAsPrefix("/") != null) ? _apiPath.substring(1) : _apiPath);

  String url() => this.baseURL() + "/" + this.path();

  String baseURL() => globals.debugModel ? (developmentURL() ?? productURL()) : productURL();

  bool needAuth() => (this.typeValue != ApiType.almirCMS && this.path() != Endpoint._requestTokenPath().rawValue && this.path() != Endpoint._revokeTokenPath().rawValue);

  int timeoutInternal() {
    if (this.typeValue == ApiType.abTesting) {
      return 60;
    }
    return (globals.debugModel == true) ? 30 : 2;
  }

  Endpoint pathedWithArgs(List<dynamic> args) {
    this._apiPath = sprintf(this._apiPath, args);
    return this;
  }

  Endpoint pathedWithQueries(Map<String, String> queries) {
    this._apiPath = MapUtils.generateMapQuery(queries);
    return this;
  }

  String productURL() {
    switch (this.typeValue) {
      case ApiType.eCommerce:
        return Domain.global.rawValue;

      case ApiType.authentication:
        return Domain.authentication.rawValue;

      case ApiType.payment:
        return Domain.payment.rawValue;

      case ApiType.content:
      case ApiType.almirCMS:
      case ApiType.marketing:
      case ApiType.abTesting:
      case ApiType.channelService:
        return Domain.china.rawValue;
    }
    return "";
  }

  String developmentURL() => "";

  factory Endpoint._requestTokenPath() => Endpoint(apiPath: "connect/token");
  factory Endpoint._revokeTokenPath() => Endpoint(apiPath: "connect/revocation");
}
