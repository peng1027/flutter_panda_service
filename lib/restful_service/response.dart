/*
 * response.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:_http';
import 'request_option.dart';

class Response {
  RequestOption requestOption;
  HttpClientResponse originalResponse;
  List<int> data;

  Response({this.requestOption, this.originalResponse, this.data});
}
