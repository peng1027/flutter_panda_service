/*
 * service.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 1/30/19 10:53 PM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'dart:core';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import '../business_service/service_comon.dart';
import '../preferences/preferences.dart';
import '../restful_service/network.dart';
import 'endpoints.dart';
import 'form_data_part.dart';

abstract class RestfulParameter {}

class HeaderKey extends EnumValue<String> {
  HeaderKey(String value) : super(rawValue: value);

  factory HeaderKey.authorization() => HeaderKey("Authorization");
  factory HeaderKey.country() => HeaderKey("FF-Country");
  factory HeaderKey.currency() => HeaderKey("FF-Currency");
  factory HeaderKey.language() => HeaderKey("Accept-Language");
  factory HeaderKey.encoding() => HeaderKey("Accept-Encoding");
  factory HeaderKey.requestId() => HeaderKey("X-SUMMER-RequestId");
}

class RestfulService {
  Future get({
    Endpoint endpoint,
    Map<String, dynamic> headers = null,
    RestfulParameter parameters = null,
  }) async {}

  Map<String, String> buildHttpHeaders(Map<String, String> headers) {
    Map<String, String> allHTTPHeaders = headers ?? Map<String, String>();

    allHTTPHeaders[HeaderKey.country().rawValue] = _prefs.countryCode();
    allHTTPHeaders[HeaderKey.currency().rawValue] = _prefs.currencyCode();
    allHTTPHeaders[HeaderKey.language().rawValue] = _prefs.languageCode();
    allHTTPHeaders[HeaderKey.encoding().rawValue] = "gzip";
    allHTTPHeaders[HeaderKey.requestId().rawValue] = UUID.uuidString();

    return allHTTPHeaders;
  }

  static Preferences get _prefs => Preferences.instance;

  void request<T>({
    Endpoint endpoint,
    RestfulMethod method,
    Map<String, String> headers,
    dynamic parameters,
    dynamic body,
    FormDataPart dataParts,
    ContentType contentType,
    ServiceEntityCompletion<T> completion,
  }) {
    var allHttpHeaders = this.buildHttpHeaders(headers);
  }
}
