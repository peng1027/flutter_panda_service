/*
 * service.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 1/30/19 10:53 PM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'dart:core';

import 'package:flutter_panda_service/restful_service/endpoints.dart';


abstract class RestfulParameter {}

class RestfulService {
  Future get({
    Endpoint endpoint,
    Map<String, dynamic> headers = null,
    RestfulParameter parameters = null,

  }) async {}
}
