/*
 * request_encoder.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 1/31/19 3:21 AM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'dart:math';

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'package:sprintf/sprintf.dart';

enum ArrayEncodingEnum { brackets, noBrackets }

class ArrayEncoding extends EnumType<ArrayEncodingEnum, String> {
  ArrayEncoding(ArrayEncodingEnum type, String rawValue) : super(typeValue: type, rawValue: rawValue);

  String encode(String key) {
    switch (this.typeValue) {
      case ArrayEncodingEnum.brackets:
        return "$key[]";
      case ArrayEncodingEnum.noBrackets:
        return key;
    }
    return "";
  }
}

enum BoolEncodingEnum { numeric, literal }

class BoolEncoding extends EnumType<BoolEncodingEnum, String> {
  BoolEncoding(BoolEncodingEnum type, String value) : super(typeValue: type, rawValue: value);

  String encoding(bool value) {
    switch (this.typeValue) {
      case BoolEncodingEnum.numeric:
        return value ? "1" : "0";
      case BoolEncodingEnum.literal:
        return value ? "true" : "false";
    }
    return "";
  }
}

class RestfulRequestBoundaryGenerator {
  static String boundary() => sprintf(
        "farfetch.boundary.%08x%08x",
        [
          Random(DateTime.now().second),
          Random(DateTime.now().millisecondsSinceEpoch),
        ],
      );
}

class RequestEncoder {
  factory RequestEncoder.shared() => RequestEncoder._internal_();
  RequestEncoder._internal_();

  String boundary;

  RequestEncoder({this.boundary = ""});
}
