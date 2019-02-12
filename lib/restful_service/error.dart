/*
 * error.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'response.dart';

enum EncodingFailedReasonType { missingURL, jsonEncodingFailed }

class EncodingFailedReason extends EnumType<EncodingFailedReasonType, Error> {
  const EncodingFailedReason(EncodingFailedReasonType type, {Error rawValue}) : super(type, rawValue);

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

class RestfulError extends EnumType<int, String> implements ErrorType {
  static const int UNKNOWN = -1;
  static const int TIMEOUT = 0;
  static const int NOT_CONNECTED_TO_INTERNET = TIMEOUT + 1;
  static const int INVALID_URL = NOT_CONNECTED_TO_INTERNET + 1;
  static const int ENCODING_FAILED = INVALID_URL + 1;
  static const int RESPONSE_VALIDATION_FAILED = ENCODING_FAILED + 1;
  static const int SYSTEM_ERROR = RESPONSE_VALIDATION_FAILED + 1;

  final String url;
  final EncodingFailedReason reason;
  final Response response;

  final int errorType;

  const RestfulError(int type, {String rawValue, this.url, this.reason, this.response, this.errorType}) : super(type, rawValue);

  factory RestfulError.unknown(Error error) => RestfulError(UNKNOWN, rawValue: "Unknown error.");
  factory RestfulError.timeout() => RestfulError(TIMEOUT);
  factory RestfulError.notConnectedToInternet() => RestfulError(NOT_CONNECTED_TO_INTERNET);
  factory RestfulError.invalidURL(String url) => RestfulError(INVALID_URL, url: url);
  factory RestfulError.encodingFailed(EncodingFailedReason reason) => RestfulError(ENCODING_FAILED, reason: reason);
  factory RestfulError.responseValidationFailed(Response response) => RestfulError(RESPONSE_VALIDATION_FAILED, response: response);
  factory RestfulError.systemError(Error error) => RestfulError(SYSTEM_ERROR, rawValue: Error.safeToString(error));

  String errorDescription() {
    switch (this.errorType) {
      case RestfulError.UNKNOWN:
        return this.rawValue ?? "unknown error";
      case RestfulError.TIMEOUT:
        return "Timeout";
      case RestfulError.NOT_CONNECTED_TO_INTERNET:
        return "Cannot connect to internet";
      case RestfulError.INVALID_URL:
        return "URL is not valid: ${this.url}";
      case RestfulError.ENCODING_FAILED:
        return "${this.reason.localizedDescription()}";
      case RestfulError.RESPONSE_VALIDATION_FAILED:
        return "Response status code was unacceptable: ${this.response.originalResponse.statusCode}";
      case RestfulError.SYSTEM_ERROR:
        return this.rawValue ?? "System error";
      default:
        return this.rawValue ?? "** error: unknown error";
    }
  }
}
