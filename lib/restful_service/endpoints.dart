/*
 * endpoints.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 1/29/19 1:54 AM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'dart:core';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'package:sprintf/sprintf.dart';

import '../flutter_panda_service.dart' as globals;

class ApiType extends EnumType<int, String> {
  ApiType(int type, String rawValue) : super(typeValue: type, rawValue: rawValue);

  static const int eCommerce = 0;
  static const int content = eCommerce + 1;
  static const int payment = content + 1;
  static const int almirCMS = payment + 1;
  static const int marketing = almirCMS + 1;
  static const int abTesting = marketing + 1;
  static const int authentication = abTesting + 1;
  static const int channelService = authentication + 1;

  factory ApiType.getECommerce() => ApiType(ApiType.eCommerce, "eCommerce");
  factory ApiType.getContent() => ApiType(ApiType.content, "content");
  factory ApiType.getPayment() => ApiType(ApiType.payment, "payment");
  factory ApiType.getAlmirCMS() => ApiType(ApiType.almirCMS, "almirCMS");
  factory ApiType.getMarketing() => ApiType(ApiType.marketing, "marketing");
  factory ApiType.getAbTesting() => ApiType(ApiType.abTesting, "abTesting");
  factory ApiType.getAuthentication() => ApiType(ApiType.authentication, "authentication");
  factory ApiType.getChannelService() => ApiType(ApiType.channelService, "channelService");
}

class Domain extends EnumType<int, String> {
  static const int global = 0;
  static const int payment = global + 1;
  static const int authentication = payment + 1;
  static const int china = authentication + 1;

  Domain(int type, String rawValue) : super(typeValue: type, rawValue: rawValue);

  factory Domain.getGlobal() => Domain(Domain.global, "https://api.farfetch.net");
  factory Domain.getPayment() => Domain(Domain.payment, "https://paymentsapi.farfetch.net");
  factory Domain.getAuthentication() => Domain(Domain.authentication, "https://api.farfetch.net/ext/auth");
  factory Domain.getChina() => Domain(Domain.china, "https://channel-service-panda.farfetch.net");
}

// Endpoint about base Endpoint URL settings
class Endpoint extends EnumType<int, String> {
  String apiPath;

  Endpoint({int apiType, this.apiPath, String rawValue}) : super(typeValue: apiType, rawValue: rawValue);

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
        return Domain.getGlobal().rawValue;

      case ApiType.authentication:
        return Domain.getAuthentication().rawValue;

      case ApiType.payment:
        return Domain.getPayment().rawValue;

      case ApiType.content:
      case ApiType.almirCMS:
      case ApiType.marketing:
      case ApiType.abTesting:
      case ApiType.channelService:
        return Domain.getChina().rawValue;
    }
    return "";
  }

  String developmentURL() => "";

  factory Endpoint._requestTokenPath() => Endpoint(rawValue: "connect/token");
  factory Endpoint._revokeTokenPath() => Endpoint(rawValue: "connect/revocation");
}
