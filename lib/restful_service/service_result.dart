/*
 * service_result.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/16/19 10:56 PM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import '../restful_service/http_response.dart';

//typedef ServiceCompletion(HttpResponse response, ErrorType error);
//typedef ServiceEntityCompletion<T>(T data, HttpResponse response, ErrorType error);

abstract class ServiceEntityResultProtocol {}

class ServiceEntityResultModel implements ServiceEntityResultProtocol {
  final dynamic data;
  final HttpResponse response;
  final ErrorType error;

  ServiceEntityResultModel({this.data, this.response, this.error});
}
