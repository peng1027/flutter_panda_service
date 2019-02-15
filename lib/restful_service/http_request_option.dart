/*
 * request.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'http_network.dart';
import 'http_form_data_part.dart';

class HttpRequestOption {
  String url;

  final HttpMethod method;
  final int timeOut;
  final Map<String, String> headers;
  final dynamic parameters;
  final HTTPContentType contentType;
  final NetworkBaseOption options;
  final List<HttpFormDataPart> formDataParts;

  HttpRequestOption({
    this.url,
    this.method,
    this.timeOut = 60,
    this.parameters,
    this.headers,
    this.formDataParts,
    this.contentType,
    this.options,
  });

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    // TODO: implement ==
    return this.method == other.method &&
        this.timeOut == other.timeout &&
        this.headers == other.headers &&
        this.parameters == other.parameters &&
        this.contentType == other.contentType &&
        this.options == other.options &&
        this.formDataParts == other.formDataParts;
  }
}
