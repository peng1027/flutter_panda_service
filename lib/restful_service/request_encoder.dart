/*
 * request_encoder.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'package:flutter_panda_service/restful_service/http_network.dart';
import 'package:sprintf/sprintf.dart';

import 'request_option.dart';

class ArrayEncoding extends EnumType<int, String> {
  static const int brackets = 0;
  static const int noBrackets = brackets + 1;

  ArrayEncoding(int type, String rawValue) : super(type, rawValue);

  String encode(String key) {
    switch (this.typeValue) {
      case ArrayEncoding.brackets:
        return "$key[]";
      case ArrayEncoding.noBrackets:
        return key;
    }
    return "";
  }
}

class BoolEncoding extends EnumType<int, String> {
  static const int numeric = 0;
  static const int literal = numeric + 1;

  const BoolEncoding(int type, String value) : super(type, value);

  String encoding(bool value) {
    switch (this.typeValue) {
      case BoolEncoding.numeric:
        return value ? "1" : "0";
      case BoolEncoding.literal:
        return value ? "true" : "false";
    }
    return "";
  }
}

class RestfulRequestBoundaryGenerator {
  static String get boundary => sprintf("farfetch.boundary.%08x%08x", [
        Random(DateTime.now().second),
        Random(DateTime.now().millisecondsSinceEpoch),
      ]);
}

class RestfulQueryHelper {
  static String query(Map<String, String> param) => _query(param);

  static String _query(Map<String, String> parameters) {
    List<String> alls = List<String>();
    parameters.forEach((k, v) => alls.add("$k=$v"));
    return alls.join("&");
  }
}

class RequestEncoder {
  static HttpClientRequest encode(HttpClientRequest request, RequestOption option) {
    if (request == null || option == null) {
      AssertionError("invalid HttpClientRequest or RequestOption");
      return request;
    }

    if (option.contentType == HTTPContentType.none) {
      return request;
    } else if (option.contentType == HTTPContentType.json) {
      return RequestEncoder.urlEncode(request, option);
    } else if (option.contentType == HTTPContentType.formURLEncoded) {
      return RequestEncoder.jsonEncode(request, option);
    } else if (option.contentType == HTTPContentType.multipartFormData) {
      return RequestEncoder.multiPartFormEncode(request, option);
    } else {
      AssertionError("invalid HTTPContentType: ${option.contentType.rawValue}");
      return null;
    }
  }

  static HttpClientRequest urlEncode(HttpClientRequest request, RequestOption option) {
    request.headers.contentType = option.contentType.toContentType();

    if (!(option.method == HTTPMethod.get || option.method == HTTPMethod.head || option.method == HTTPMethod.delete)) {
      final String query = RestfulQueryHelper.query(option.parameters);
      List<int> data = utf8.encode(query);
      request.write(data);
    }

    return request;
  }

  static HttpClientRequest jsonEncode(HttpClientRequest request, RequestOption option) {
    request.headers.contentType = option.contentType.toContentType();

    if (option.parameters is List<int>) {
      request.write(option.parameters);
    } else if (option.parameters is Map<String, String>) {
      final String jsonStr = JsonCodec().encode(option.parameters);
      List<int> jsonData = Utf8Codec().encode(jsonStr);
      request.write(jsonData);
    }

    return request;
  }

  static HttpClientRequest multiPartFormEncode(HttpClientRequest request, RequestOption option) {
    request.headers.contentType = option.contentType.toContentType();

    final String boundary = RestfulRequestBoundaryGenerator.boundary;

    List<int> bodyData = List<int>();

    if (option.parameters is Map<String, String>) {
      option.parameters.forEacH((key, val) {
        String bodyStr = "";
        final dynamic valFull = val ?? "null";

        bodyStr += "--$boundary\r\n";
        bodyStr += "Content-Disposition: form-data; name=\"$key\"";
        bodyStr += "\r\n\r\n$valFull\r\n";

        List<int> paramData = Utf8Codec().encode(bodyStr);
        bodyData.addAll(paramData);
      });
    } else {
      // EMPTY
    }

    if (option.formDataPart != null) {
      option.formDataPart.forEach((formData) {
        bodyData.addAll(formData.formData(boundary));
      });
    }

    String endStr = "--$boundary--\r\n";
    List<int> endData = Utf8Codec().encode(endStr);
    bodyData.addAll(endData);

    // assign htth body
    request.write(bodyData);

    return request;
  }
}
