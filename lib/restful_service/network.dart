/*
 * network.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 1/30/19 11:13 PM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'package:meta/meta.dart';

import 'response.dart';

typedef RestfulRequestCompletion(RestfulResult result);

class RestfulResult {
  final Response response;
  final Error error;

  RestfulResult({@required this.response, this.error});

  factory RestfulResult.success(Response response) =>
      RestfulResult(response: response);
  factory RestfulResult.failure(Response response, Error error) =>
      RestfulResult(response: response, error: error);
}

enum RestfulMethodType { options, get, head, post, put, patch, delete, trace, connect }
// RestfulMethod method for RESTful request.
class RestfulMethod extends EnumType<RestfulMethodType, String> {
  RestfulMethod(RestfulMethodType method, String rawValue) : super(typeValue: method, rawValue: rawValue);

  factory RestfulMethod.options() => RestfulMethod(RestfulMethodType.options, "OPTIONS");
  factory RestfulMethod.get() => RestfulMethod(RestfulMethodType.get, "GET");
  factory RestfulMethod.head() => RestfulMethod(RestfulMethodType.head, "HEAD");
  factory RestfulMethod.post() => RestfulMethod(RestfulMethodType.post, "POST");
  factory RestfulMethod.put() => RestfulMethod(RestfulMethodType.put, "PUT");
  factory RestfulMethod.patch() => RestfulMethod(RestfulMethodType.patch, "PATCH");
  factory RestfulMethod.delete() => RestfulMethod(RestfulMethodType.delete, "DELETE");
  factory RestfulMethod.trace() => RestfulMethod(RestfulMethodType.trace, "TRACE");
  factory RestfulMethod.connect() => RestfulMethod(RestfulMethodType.connect, "CONNECT");
}

enum ContentTypeEnum { none, json, formURLEncoded, multipartFormData }
// ContentType content type for RESTful request.
class ContentType extends EnumType<ContentTypeEnum, String> {
  ContentType(ContentTypeEnum type, String rawValue) : super(typeValue: type, rawValue: rawValue);

  factory ContentType.none() => ContentType(ContentTypeEnum.none, "");
  factory ContentType.json() => ContentType(ContentTypeEnum.json, "application/json");
  factory ContentType.formURLEncoded() => ContentType(ContentTypeEnum.formURLEncoded ,"application/x-www-form-urlencoded");
  factory ContentType.multipartFormData() => ContentType(ContentTypeEnum.multipartFormData ,"multipart/form-data; boundary=");
}
