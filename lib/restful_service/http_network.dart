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

enum HTTPMethodType { options, get, head, post, put, patch, delete, trace, connect }

// HTTPMethod method for RESTful request.
class HTTPMethod extends EnumType<HTTPMethodType, String> {
  const HTTPMethod(HTTPMethodType method, String rawValue) : super(method, rawValue);

  static const HTTPMethod options = const HTTPMethod(HTTPMethodType.options, "OPTIONS");
  static const HTTPMethod get = const HTTPMethod(HTTPMethodType.get, "GET");
  static const HTTPMethod head = const HTTPMethod(HTTPMethodType.head, "HEAD");
  static const HTTPMethod post = const HTTPMethod(HTTPMethodType.post, "POST");
  static const HTTPMethod put = const HTTPMethod(HTTPMethodType.put, "PUT");
  static const HTTPMethod patch = const HTTPMethod(HTTPMethodType.patch, "PATCH");
  static const HTTPMethod delete = const HTTPMethod(HTTPMethodType.delete, "DELETE");
  static const HTTPMethod trace = const HTTPMethod(HTTPMethodType.trace, "TRACE");
  static const HTTPMethod connect = const HTTPMethod(HTTPMethodType.connect, "CONNECT");
}

enum ContentTypeEnum { none, json, formURLEncoded, multipartFormData }

// ContentType content type for RESTful request.
class HTTPContentType extends EnumType<ContentTypeEnum, String> {
  const HTTPContentType(ContentTypeEnum type, String rawValue) : super(type, rawValue);

  static const HTTPContentType none = const HTTPContentType(ContentTypeEnum.none, "");
  static const HTTPContentType json = const HTTPContentType(ContentTypeEnum.json, "application/json");
  static const HTTPContentType formURLEncoded =
      const HTTPContentType(ContentTypeEnum.formURLEncoded, "application/x-www-form-urlencoded");
  static const HTTPContentType multipartFormData =
      const HTTPContentType(ContentTypeEnum.multipartFormData, "multipart/form-data; boundary=");

  ContentType toContentType() => ContentType.parse(rawValue);
}

abstract class NetworkBaseOption {}

class HTTPNetwork {
  static HTTPTaskBase getNetworkRequest(
      {@required String url,
      HTTPMethod method = HTTPMethod.get,
      Map<String, String> headers = null,
      parameters = null,
      HTTPContentType contentType = HTTPContentType.formURLEncoded,
      NetworkBaseOption options = null,
      NetworkCompletion completion = null}) {
    RequestOption option = RequestOption(
        url: url,
        method: method,
        headers: headers,
        parameters: parameters,
        contentType: contentType,
        options: options,
        completion: completion);
    return _request(option);
  }

  static HTTPTaskBase _request(RequestOption option) {
    if (option.method == HTTPMethod.get) {
      return GET(option);
    } else if (option.method == HTTPMethod.post) {
      return POST(option);
    } else {
      AssertionError("invalid HTTP request method");
    }
  }
}
