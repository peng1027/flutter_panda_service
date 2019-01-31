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

class ArrayEncoding extends EnumType<int, String> {
  static const int brackets = 0;
  static const int noBrackets = brackets + 1;

  ArrayEncoding(int type, String rawValue) : super(typeValue: type, rawValue: rawValue);

  String encode(String key) {
    switch (this.typeValue) {
      case ArrayEncoding.brackets:
        return "$key[]";
      case ArrayEncoding.noBrackets:
        return key;
    }
    return "";
  }
}

class BoolEncoding extends EnumType<int, String> {
  static const int numeric = 0;
  static const int literal = numeric + 1;

  BoolEncoding(int type, String value) : super(typeValue: type, rawValue: value);

  String encoding(bool value) {
    switch (this.typeValue) {
      case BoolEncoding.numeric:
        return value ? "1" : "0";
      case BoolEncoding.literal:
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
