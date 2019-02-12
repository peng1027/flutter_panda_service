/*
 * network.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:io';
import 'package:meta/meta.dart';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import 'error.dart';
import 'request_option.dart';
import 'form_data_part.dart';
import 'http_task.dart';
import 'response.dart';

typedef NetworkCompletion(NetworkResult result);

class NetworkResult {
  final Response response;
  final RestfulError error;

  NetworkResult({@required this.response, this.error});

  factory NetworkResult.success(Response response) => NetworkResult(response: response);
  factory NetworkResult.failure(Response response, RestfulError error) =>
      NetworkResult(response: response, error: error);
}

// HTTPMethod method for RESTful request.
class HTTPMethod extends EnumType<int, String> {
  static const int OPTIONS = 0;
  static const int GET = OPTIONS + 1;
  static const int HEAD = GET + 1;
  static const int POST = HEAD + 1;
  static const int PUT = POST + 1;
  static const int PATCH = PUT + 1;
  static const int DELETE = PATCH + 1;

  const HTTPMethod(int method, String rawValue) : super(method, rawValue);

  static const HTTPMethod options = const HTTPMethod(OPTIONS, "OPTIONS");
  static const HTTPMethod get = const HTTPMethod(GET, "GET");
  static const HTTPMethod head = const HTTPMethod(HEAD, "HEAD");
  static const HTTPMethod post = const HTTPMethod(POST, "POST");
  static const HTTPMethod put = const HTTPMethod(PUT, "PUT");
  static const HTTPMethod patch = const HTTPMethod(PATCH, "PATCH");
  static const HTTPMethod delete = const HTTPMethod(DELETE, "DELETE");
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
  static const HTTPContentType formURLEncoded =
      const HTTPContentType(FORMURLENCODED, "application/x-www-form-urlencoded");
  static const HTTPContentType multipartFormData =
      const HTTPContentType(MULTIPARTFORMDATA, "multipart/form-data; boundary=");

  ContentType toContentType() => ContentType.parse(rawValue);
}

abstract class NetworkBaseOption {}

class HTTPNetwork {
  static HTTPTaskBase getNetworkRequest(
      {@required String url,
      HTTPMethod method = HTTPMethod.get,
      int timeOut = 60,
      Map<String, String> headers,
      dynamic parameters,
      HTTPContentType contentType = HTTPContentType.formURLEncoded,
      NetworkBaseOption options,
      List<FormDataPart> formDataParts,
      NetworkCompletion completion}) {
    RequestOption option = RequestOption(
        url: url,
        method: method,
        timeOut: timeOut,
        headers: headers,
        parameters: parameters,
        contentType: contentType,
        options: options,
        formDataParts: formDataParts,
        completion: completion);
    return _request(option);
  }

  static HTTPTaskBase _request(RequestOption option) => HTTPTaskBase(option);
}
