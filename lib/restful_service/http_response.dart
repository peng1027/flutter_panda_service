/*
 * http_response.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:_http';
import 'http_request_option.dart';

class HttpResponse {
  HttpRequestOption requestOption;
  HttpClientResponse originalResponse;
  List<int> data;

  HttpResponse({this.requestOption, this.originalResponse, this.data});

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    return this.requestOption == other.requestOption && this.originalResponse == other.originalResponse && this.data == other.data;
  }
}
