/*
 * request.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'http_network.dart';
import 'form_data_part.dart';

class RequestOption {
  String url;

  final HTTPMethod method;
  final int timeOut;
  final Map<String, String> headers;
  final dynamic parameters;
  final HTTPContentType contentType;
  final NetworkBaseOption options;
  final List<FormDataPart> formDataPart;
  final NetworkCompletion completion;

  RequestOption({
    this.url,
    this.method,
    this.timeOut = 60,
    this.parameters,
    this.headers,
    this.formDataPart,
    this.contentType,
    this.options,
    this.completion,
  });
}
