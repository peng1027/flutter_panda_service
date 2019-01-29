/*
 * response.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 1/30/19 5:02 AM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'dart:_http';
import 'package:meta/meta.dart';

import 'request.dart';

class Response {
  final Request request;
  final HttpClientResponse originalResponse;
  final List<int> data;

  Response({@required this.request, this.originalResponse, this.data});
}
