import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:sprintf/sprintf.dart';

import '../flutter_panda_service.dart' as globals;

enum enumApiType {
  eCommerce,
  content,
  payment,
  almirCMS,
  marketing,
  abTesting,
  authentication,
  channelService,
}

class ApiType {
  static const String eCommerce = "eCommerce";
  static const String content = "content";
  static const String payment = "payment";
  static const String almirCMS = "almirCMS";
  static const String marketing = "marketing";
  static const String abTesting = "abTesting";
  static const String authentication = "authentication";
  static const String channelService = "channelService";
}

class Domain {
  static const String global = "https://api.farfetch.net";
  static const String payment = "https://paymentsapi.farfetch.net";
  static const String authentication = "https://api.farfetch.net/ext/auth";
  static const String china = "https://channel-service-panda.farfetch.net";
}

class Endpoint {
  final enumApiType apiType;
  String apiPath;

  Endpoint({@required this.apiType, @required this.apiPath});

  String path() {
    return ((apiPath.matchAsPrefix("/") != null) ? apiPath.substring(1) : apiPath);
  }

  String url() {
    return this.baseURL() + "/" + this.path();
  }

  bool needAuth() {
    return (apiType != enumApiType.almirCMS &&
        this.path() != Endpoint._requestTokenPath &&
        this.path() != _revokeTokenPath);
  }

  int timeoutInternal() {
    if (this.apiType == enumApiType.abTesting) {
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
    switch (this.apiType) {
      case enumApiType.eCommerce:
        return Domain.global;

      case enumApiType.authentication:
        return Domain.authentication;

      case enumApiType.payment:
        return Domain.payment;

      case enumApiType.content:
      case enumApiType.almirCMS:
      case enumApiType.marketing:
      case enumApiType.abTesting:
      case enumApiType.channelService:
        return Domain.china;
    }
    return "";
  }

  String developmentURL() {
    return "";
  }

  static const String _requestTokenPath = "connect/token";
  static const String _revokeTokenPath = "connect/revocation";
}
