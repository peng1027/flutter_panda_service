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
  static const int global = 0;
  static const int payment = global + 1;
  static const int authentication = payment + 1;
  static const int china = authentication + 1;

  const Domain(int type, String rawValue) : super(type, rawValue);

  static const Domain Global = const Domain(Domain.global, "https://api.farfetch.net");
  static const Domain Payment = const Domain(Domain.payment, "https://paymentsapi.farfetch.net");
  static const Domain Authentication = const Domain(Domain.authentication, "https://api.farfetch.net/ext/auth");
  static const Domain China = const Domain(Domain.china, "https://channel-service-panda.farfetch.net");
}

// Endpoint about base Endpoint URL settings
class Endpoint extends EnumType<int, String> {
  String apiPath;

  Endpoint({int apiType, this.apiPath, String rawValue}) : super(apiType, rawValue);

  String path() => ((apiPath.matchAsPrefix("/") != null) ? apiPath.substring(1) : apiPath);

  String url() => this.baseURL() + "/" + this.path();

  bool needAuth() => (this.typeValue != ApiType.almirCMS &&
      this.path() != Endpoint._requestTokenPath().rawValue &&
      this.path() != Endpoint._revokeTokenPath().rawValue);

  int timeoutInternal() {
    if (this.typeValue == ApiType.abTesting) {
      return 60;
    }
    return (globals.debugModel == true) ? 30 : 2;
  }

  Endpoint pathed(List<dynamic> args) {
    this.apiPath = sprintf(this.apiPath, args);
    return this;
  }

  String baseURL() {
    return globals.debugModel ? (developmentURL() ?? productURL()) : productURL();
  }

  String productURL() {
    switch (this.typeValue) {
      case ApiType.eCommerce:
        return Domain.Global.rawValue;

      case ApiType.authentication:
        return Domain.Authentication.rawValue;

      case ApiType.payment:
        return Domain.Payment.rawValue;

      case ApiType.content:
      case ApiType.almirCMS:
      case ApiType.marketing:
      case ApiType.abTesting:
      case ApiType.channelService:
        return Domain.China.rawValue;
    }
    return "";
  }

  String developmentURL() => "";

  factory Endpoint._requestTokenPath() => Endpoint(rawValue: "connect/token");
  factory Endpoint._revokeTokenPath() => Endpoint(rawValue: "connect/revocation");
}
