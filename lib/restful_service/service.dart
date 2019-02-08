/*
 * service.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:core';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import '../business_service/service_comon.dart';
import '../preferences/preferences.dart';
import 'http_network.dart';
import 'endpoints.dart';
import 'form_data_part.dart';

abstract class RestfulParameter {}

class HeaderKey extends EnumValue<String> {
  const HeaderKey(String value) : super(value);

  static const HeaderKey authorization = const HeaderKey("Authorization");
  static const HeaderKey country = const HeaderKey("FF-Country");
  static const HeaderKey currency = const HeaderKey("FF-Currency");
  static const HeaderKey language = const HeaderKey("Accept-Language");
  static const HeaderKey encoding = const HeaderKey("Accept-Encoding");
  static const HeaderKey requestId = const HeaderKey("X-SUMMER-RequestId");
}

class RestfulService {
  Future get({
    Endpoint endpoint,
    Map<String, dynamic> headers = null,
    RestfulParameter parameters = null,
  }) async {}

  Map<String, String> buildHttpHeaders(Map<String, String> headers) {
    Map<String, String> allHTTPHeaders = headers ?? Map<String, String>();

    allHTTPHeaders[HeaderKey.country.rawValue] = _prefs.countryCode();
    allHTTPHeaders[HeaderKey.currency.rawValue] = _prefs.currencyCode();
    allHTTPHeaders[HeaderKey.language.rawValue] = _prefs.languageCode();
    allHTTPHeaders[HeaderKey.encoding.rawValue] = "gzip";
    allHTTPHeaders[HeaderKey.requestId.rawValue] = UUID.uuidString();

    return allHTTPHeaders;
  }

  static Preferences get _prefs => Preferences.instance;

  void request<T>({
    Endpoint endpoint,
    HTTPMethod method,
    Map<String, String> headers,
    dynamic parameters,
    dynamic body,
    FormDataPart dataParts,
    HTTPContentType contentType,
    ServiceEntityCompletion<T> completion,
  }) {
    var allHttpHeaders = this.buildHttpHeaders(headers);
  }
}
