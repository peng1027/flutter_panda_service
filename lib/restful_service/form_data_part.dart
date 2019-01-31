/*
 * form_data_part.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 1/31/19 12:49 AM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'dart:convert';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

class FormDataPartType extends EnumType<int, String> {
  static const int data = 0;
  static const int png = data + 1;
  static const int jpg = png + 1;

  FormDataPartType(int type, String rawValue) : super(typeValue: type, rawValue: rawValue);

  factory FormDataPartType.getData() => FormDataPartType(FormDataPartType.data, "application/octet-stream");
  factory FormDataPartType.getPng() => FormDataPartType(FormDataPartType.png, "image/png");
  factory FormDataPartType.getJpg() => FormDataPartType(FormDataPartType.jpg, "image/jpeg");
}

class FormDataPart {
  final String boundary = "";

  final List<int> data;
  final String name;
  final String fileName;
  final FormDataPartType mineType;

  FormDataPart({this.data, this.name, this.fileName, this.mineType});

  List<int> formData() {
    String body = "";
    body += "--${this.boundary}\r\n";
    body += "Content-Disposition: form-data; ";
    body += "name=\"${this.name}\"";
    if (this.fileName.isNotEmpty) {
      body += "; filename=\"${this.fileName}\"";
    }
    body += "\r\n";
    body += "Content-Type: ${this.mineType.rawValue}\r\n\r\n";

    var data = utf8.encode(body);
    var end = utf8.encode("\r\n");

    return [data, this.data, end].expand((pair) => pair).toList();
  }
}
