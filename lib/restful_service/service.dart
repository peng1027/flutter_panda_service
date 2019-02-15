/*
 * service.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:convert';
import 'dart:core';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'package:flutter_panda_service/restful_service/http_result.dart';
import 'package:flutter_panda_service/restful_service/serializable_model.dart';
import 'package:flutter_panda_service/restful_service/service_manager.dart';
import 'package:flutter_panda_service/restful_service/service_result.dart';

import '../authentication/authentication_ext.dart';
import '../preferences/preferences.dart';
import 'http_network.dart';
import 'endpoints.dart';
import 'http_form_data_part.dart';

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

  Future<ServiceEntityResultProtocol> request({
    Endpoint endpoint,
    HttpMethod method,
    int timeOut,
    Map<String, String> headers,
    dynamic parameters, // url external query
    dynamic body, // http body
    List<HttpFormDataPart> dataParts,
    HTTPContentType contentType,
  }) async {
    var allHttpHeaders = this.buildHttpHeaders(headers);

    // TODO: 这里需要通过http_task来发起http的网络请求
    AuthenticationExt.instance.futureForRequestTokenIfNeeded(endpoint.needAuth()).then((authToken) {
      allHttpHeaders[HeaderKey.authorization.rawValue] = "Bearer ${authToken.accessToken}";
      if (dataParts != null) {
        HTTPNetwork.upload(
          endpoint.url(),
          method: method,
          headers: allHttpHeaders,
          parameters: parameters,
          formDataParts: dataParts,
        ).then((serviceEntityData) {
          // TODO: coding here for further data decoding.
        });
      } else {}
    }).catchError((error) {});
  }

  // private helper

  static ServiceEntityResultModel _handleResult(HttpResult result) {
    switch (result.rawValue) {
      case HttpResult.SUCCESS:
        List<int> data = result.response.data;

        if (data == null || data.isEmpty) {
          return ServiceEntityResultModel(data: Map<String, dynamic>(), response: result.response);
        }

        String jsonStr = Utf8Codec().decode(result.response.data);
        dynamic jsonData = JsonCodec().decode(jsonStr);
        return ServiceEntityResultModel(data: jsonData, response: result.response);

      case HttpResult.FAILURE:
        return ServiceEntityResultModel(response: result.response, error: result.error);

      default:
        return null;
    }
  }
}
