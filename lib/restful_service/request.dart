/*
 * request.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 1/30/19 5:02 AM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'network.dart';
import 'form_data_part.dart';

class Request {
  final List<FormDataPart> formDataPart;
  final String url;
  final RestfulMethod method;
  final dynamic parameters;
  final Map<String, String> headers;

  Request({
    this.parameters,
    this.headers,
    this.formDataPart,
    this.url,
    this.method,
  });

  void resume() {}
  void suspend() {}
  void cancel() {}
}
