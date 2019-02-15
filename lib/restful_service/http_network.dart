/*
 * network.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:convert';
import 'dart:io';
import 'package:flutter_panda_service/restful_service/http_result.dart';
import 'package:flutter_panda_service/restful_service/serializable_model.dart';
import 'package:flutter_panda_service/restful_service/service_result.dart';
import 'package:meta/meta.dart';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import 'http_request_option.dart';
import 'http_form_data_part.dart';
import 'http_task.dart';

// HTTPMethod method for RESTful request.
class HttpMethod extends EnumType<int, String> {
  static const int GET = 0;
  static const int HEAD = GET + 1;
  static const int POST = HEAD + 1;
  static const int PUT = POST + 1;
  static const int PATCH = PUT + 1;
  static const int DELETE = PATCH + 1;

  const HttpMethod(int method, String rawValue) : super(method, rawValue);

  static const HttpMethod get = const HttpMethod(GET, "GET");
  static const HttpMethod head = const HttpMethod(HEAD, "HEAD");
  static const HttpMethod post = const HttpMethod(POST, "POST");
  static const HttpMethod put = const HttpMethod(PUT, "PUT");
  static const HttpMethod patch = const HttpMethod(PATCH, "PATCH");
  static const HttpMethod delete = const HttpMethod(DELETE, "DELETE");
}

enum ContentTypeEnum {
  none,
  json,
  formURLEncoded,
  multipartFormData,
}

// ContentType content type for RESTful request.
class HTTPContentType extends EnumType<int, String> {
  static const int NONE = 0;
  static const int JSON = NONE + 1;
  static const int FORMURLENCODED = JSON + 1;
  static const int MULTIPARTFORMDATA = FORMURLENCODED + 1;

  const HTTPContentType(int type, String rawValue) : super(type, rawValue);

  static const HTTPContentType none = const HTTPContentType(NONE, "");
  static const HTTPContentType json = const HTTPContentType(JSON, "application/json");
  static const HTTPContentType formURLEncoded = const HTTPContentType(FORMURLENCODED, "application/x-www-form-urlencoded");
  static const HTTPContentType multipartFormData = const HTTPContentType(MULTIPARTFORMDATA, "multipart/form-data; boundary=");

  ContentType toContentType() => ContentType.parse(rawValue);
}

abstract class NetworkBaseOption {}

class HTTPNetwork {
  static Future<HttpResult> request(
    String url, {
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers,
    dynamic parameters,
    HTTPContentType contentType = HTTPContentType.formURLEncoded,
    NetworkBaseOption options,
  }) async {
    HttpTask task = _getNetworkRequest(
      url: url,
      method: method,
      headers: headers,
      parameters: parameters,
      contentType: contentType,
      options: options,
    );
    return await task.request();
  }

  static Future<HttpResult> upload(
    String url, {
    HttpMethod method = HttpMethod.post,
    Map<String, String> headers,
    dynamic parameters,
    List<HttpFormDataPart> formDataParts,
    NetworkBaseOption options,
  }) async {
    HttpTask task = _getNetworkRequest(
      url: url,
      method: method,
      headers: headers,
      parameters: parameters,
      formDataParts: formDataParts,
      contentType: HTTPContentType.multipartFormData,
      options: options,
    );
    return await task.request();
  }

  // private helpers

  static HttpTask _getNetworkRequest({
    @required String url,
    HttpMethod method = HttpMethod.get,
    int timeOut = 60,
    Map<String, String> headers,
    dynamic parameters,
    HTTPContentType contentType = HTTPContentType.formURLEncoded,
    NetworkBaseOption options,
    List<HttpFormDataPart> formDataParts,
  }) {
    HttpRequestOption option = HttpRequestOption(
      url: url,
      method: method,
      timeOut: timeOut,
      headers: headers,
      parameters: parameters,
      contentType: contentType,
      options: options,
      formDataParts: formDataParts,
    );
    return HttpTask(option);
  }
}
