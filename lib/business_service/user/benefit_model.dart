/*
 * benefit_model.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';

part 'benefit_model.g.dart';

@JsonSerializable(nullable: false)
class BenefitModel {
  final String id;
  final String code;
  final bool isActive;
  final Map<String, dynamic> metadata;

  BenefitModel({@required this.id, this.code, this.isActive, this.metadata});

  factory BenefitModel.fromJson(Map<String, dynamic> json) => _$BenefitModelFromJson(json);
  Map<String, dynamic> toJson() => _$BenefitModelToJson(this);

  @override
  int get hashCode => this.code.hashCode ^ this.isActive.hashCode ^ this.metadata.hashCode;

  @override
  bool operator ==(other) {
    if (other != null && other is BenefitModel) {
      BenefitModel another = other;
      return this.code == another.code && this.isActive == another.isActive && this.metadata == another.metadata;
    } else {
      return false;
    }
  }

  bool isEqual(BenefitModel other) => this == other;
}
