/*
 * form_data_part.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'dart:convert';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

class FormDataPartType extends EnumType<int, String> {
  static const int data = 0;
  static const int png = data + 1;
  static const int jpg = png + 1;

  const FormDataPartType(int type, String rawValue) : super(type, rawValue);

  static const FormDataPartType Data = const FormDataPartType(FormDataPartType.data, "application/octet-stream");
  static const FormDataPartType Png = const FormDataPartType(FormDataPartType.png, "image/png");
  static const FormDataPartType Jpg = const FormDataPartType(FormDataPartType.jpg, "image/jpeg");
}

class FormDataPart {
  final List<int> data;
  final String name;
  final String fileName;
  final FormDataPartType mineType;

  FormDataPart({this.data, this.name, this.fileName, this.mineType});

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
