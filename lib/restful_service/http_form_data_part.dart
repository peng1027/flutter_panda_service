/*
 * http_form_data_part.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:convert';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

class HttpFormDataPartType extends EnumType<int, String> {
  static const int DATA = 0;
  static const int PNG = DATA + 1;
  static const int JPG = PNG + 1;

  const HttpFormDataPartType(int type, String rawValue) : super(type, rawValue);

  static HttpFormDataPartType get data => const HttpFormDataPartType(HttpFormDataPartType.DATA, "application/octet-stream");
  static HttpFormDataPartType get png => const HttpFormDataPartType(HttpFormDataPartType.PNG, "image/png");
  static HttpFormDataPartType get jpg => const HttpFormDataPartType(HttpFormDataPartType.JPG, "image/jpeg");
}

class HttpFormDataPart {
  final List<int> data;
  final String name;
  final String fileName;
  final HttpFormDataPartType mineType;

  HttpFormDataPart({this.data, this.name, this.fileName, this.mineType});

  List<int> formData(String boundary) {
    String body = "";
    body += "--$boundary\r\n";
    body += "Content-Disposition: form-data; ";
    body += "name=\"${this.name}\"";
    if (this.fileName.isNotEmpty) {
      body += "; filename=\"${this.fileName}\"";
    }
    body += "\r\n";
    body += "Content-Type: ${this.mineType.rawValue}\r\n\r\n";

    var data = utf8.encode(body);
    var end = utf8.encode("\r\n");

    return [data, this.data, end].expand((pair) => pair);
  }
}
