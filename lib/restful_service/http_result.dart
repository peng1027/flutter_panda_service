/*
 * http_result.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/16/19 11:04 PM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:meta/meta.dart';
import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'http_response.dart';

//typedef HttpCompletion(HttpResult result);

class HttpResult extends EnumValue<int> {
  static const int FAILURE = 0;
  static const int SUCCESS = FAILURE + 1;

  final HttpResponse response;
  final ErrorType error;

  HttpResult(int type, {@required this.response, this.error}) : super(type);

  factory HttpResult.success(HttpResponse response) => HttpResult(SUCCESS, response: response);
  factory HttpResult.failure(HttpResponse response, ErrorType error) => HttpResult(FAILURE, response: response, error: error);
}
