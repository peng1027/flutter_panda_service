/*
 * error.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 1/31/19 2:01 AM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'response.dart';

enum EncodingFailedReasonType { missingURL, jsonEncodingFailed }

class EncodingFailedReason extends EnumType<EncodingFailedReasonType, Error> {
  EncodingFailedReason(EncodingFailedReasonType type, {Error rawValue}) : super(typeValue: type, rawValue: rawValue);

  factory EncodingFailedReason.missingURL() => EncodingFailedReason(EncodingFailedReasonType.missingURL);

  factory EncodingFailedReason.jsonEncodingFailed(Error err) => EncodingFailedReason(EncodingFailedReasonType.jsonEncodingFailed, rawValue: err);

  String localizedDescription() {
    if (this.typeValue == EncodingFailedReasonType.missingURL) {
      return "URL request to encode was missing a URL";
    } else if (this.typeValue == EncodingFailedReasonType.jsonEncodingFailed) {
      return "JSON could not be encoded because of error:\n${Error.safeToString(this.rawValue)}";
    } else {
      return "** error: unknown";
    }
  }
}

class RestfulError extends EnumType<int, String> {
  static const int timeout = 0;
  static const int notConnectedToInternet = timeout + 1;
  static const int invalidURL = notConnectedToInternet + 1;
  static const int encodingFailed = invalidURL + 1;
  static const int responseValidationFailed = encodingFailed + 1;

  final String url;
  final EncodingFailedReason reason;
  final Response response;

  int errorType;

  RestfulError(
    int type, {
    String rawValue,
    this.url,
    this.reason,
    this.response,
  }) : super(typeValue: type, rawValue: rawValue);

  factory RestfulError.getTimeout() => RestfulError(RestfulError.timeout);

  factory RestfulError.getNotConnectedToInternet() => RestfulError(RestfulError.notConnectedToInternet);

  factory RestfulError.getInvalidURL(String url) => RestfulError(RestfulError.invalidURL, url: url);

  factory RestfulError.getEncodingFailed(EncodingFailedReason reason) => RestfulError(RestfulError.encodingFailed, reason: reason);

  factory RestfulError.getResponseValidationFailed(Response response) => RestfulError(RestfulError.responseValidationFailed, response: response);

  String errorDescription() {
    switch (this.errorType) {
      case RestfulError.timeout:
        return "Timeout";
      case RestfulError.notConnectedToInternet:
        return "Cannot connect to internet";
      case RestfulError.invalidURL:
        return "URL is not valid: ${this.url}";
      case RestfulError.encodingFailed:
        return "${this.reason.localizedDescription()}";
      case RestfulError.responseValidationFailed:
        return "Response status code was unacceptable: ${this.response.originalResponse.statusCode}";
      default:
        return "** error: unknown error";
    }
  }
}
