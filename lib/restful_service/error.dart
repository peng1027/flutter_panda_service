/*
 * error.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 1/31/19 2:01 AM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'package:flutter_panda_service/restful_service/response.dart';

enum EncodingFailedReasonType { missingURL, jsonEncodingFailed }

class EncodingFailedReason extends EnumType<EncodingFailedReasonType, Error> {
  EncodingFailedReason(EncodingFailedReasonType type, {Error rawValue})
      : super(typeValue: type, rawValue: rawValue);

  factory EncodingFailedReason.missingURL() =>
      EncodingFailedReason(EncodingFailedReasonType.missingURL);

  factory EncodingFailedReason.jsonEncodingFailed(Error err) =>
      EncodingFailedReason(EncodingFailedReasonType.jsonEncodingFailed,
          rawValue: err);

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

enum RestfulErrorType {
  timeout,
  notConnectedToInternet,
  invalidURL,
  encodingFailed,
  responseValidationFailed
}

class RestfulError extends EnumType<RestfulErrorType, String> {
  final String url;
  final EncodingFailedReason reason;
  final Response response;

  RestfulErrorType errorType;

  RestfulError(
    RestfulErrorType type, {
    String rawValue,
    this.url,
    this.reason,
    this.response,
  }) : super(typeValue: type, rawValue: rawValue);

  factory RestfulError.timeout() => RestfulError(RestfulErrorType.timeout);

  factory RestfulError.notConnectedToInternet() =>
      RestfulError(RestfulErrorType.notConnectedToInternet);

  factory RestfulError.invalidURL(String url) =>
      RestfulError(RestfulErrorType.invalidURL, url: url);

  factory RestfulError.encodingFailed(EncodingFailedReason reason) =>
      RestfulError(RestfulErrorType.encodingFailed, reason: reason);

  factory RestfulError.responseValidationFailed(Response response) =>
      RestfulError(RestfulErrorType.responseValidationFailed,
          response: response);

  String errorDescription() {
    switch (this.errorType) {
      case RestfulErrorType.timeout:
        return "Timeout";
      case RestfulErrorType.notConnectedToInternet:
        return "Cannot connect to internet";
      case RestfulErrorType.invalidURL:
        return "URL is not valid: ${this.url}";
      case RestfulErrorType.encodingFailed:
        return "${this.reason.localizedDescription()}";
      case RestfulErrorType.responseValidationFailed:
        return "Response status code was unacceptable: ${this.response.originalResponse.statusCode}";
      default:
        return "** error: unknown error";
    }
  }
}
