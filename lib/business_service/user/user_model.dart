/*
 * user_model.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 1/30/19 3:45 AM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'dart:math';
import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';

import 'benefit_model.dart';

part 'user_model.g.dart';

enum UserType { guest, registered }

enum UserTier { none, bronze, silver, gold, platinum, privateClient }

class Gender {
  static const String notDefine = "NotDefined";
  static const String male = "Male";
  static const String female = "Female";
}

@JsonSerializable(nullable: false)
class UserModel {
  final int id;
  final String username;
  final String passsword;
  final String name;
  final String email;
  final String countryCode;
  final String phonenumber;
  final DateTime dateOfBirth;
  final String gender;
  final String bagId;
  final String wishlistId;
  final int personalShopperId;
  final bool receiveNewsletters;
  final DateTime expiryDate;

  UserModel({
    @required this.id,
    this.username,
    this.passsword,
    this.name,
    this.email,
    this.countryCode,
    this.phonenumber,
    this.dateOfBirth,
    this.gender,
    this.bagId,
    this.wishlistId,
    this.personalShopperId,
    this.receiveNewsletters,
    this.expiryDate,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel.copy(
    this.id,
    this.username,
    this.passsword,
    this.name,
    this.email,
    this.countryCode,
    this.phonenumber,
    this.dateOfBirth,
    this.gender,
    this.bagId,
    this.wishlistId,
    this.personalShopperId,
    this.receiveNewsletters,
    this.expiryDate,
  );

  List<BenefitModel> benefits = List<BenefitModel>();
  void updateUserBenefits(List<BenefitModel> benefits) {
    this.benefits = benefits;
  }

  bool isGuest() => username.isEmpty;

  UserType get userType => this.isGuest() ? UserType.guest : UserType.registered;

  String firstName() {
    List<String> names = this.name.split(" ");
    return names.first ?? "";
  }

  String lastName() {
    List<String> names = name.split(" ");
    return names.length > 1 ? names.last : "";
  }

  String nameExcludingLast() {
    if (this.name == null) {
      return "";
    }
    int count = max(0, name.length - this.lastName().length);
    return name.substring(0, count).toString().trim();
  }

  ////////////////////////////////////////////////////////////////////////////
  static const String restrictedBrandsBenefit = "restricted-brands";
  static const String privateSaleBenefit = "private-sale";
  static const String vipPrivateSaleBenefit = "vip-private-sale";
  static const String privateClientBenefit = "private-client";

  static const String metadataCampaignCode = "campaign-code";
  static const String metadataCampaignInviteOnly = "invite-only";

  bool get hasAnyActiveBenefits => this.benefits.map((benefit) => benefit.isActive).toList().isNotEmpty;

  bool get hasInviteOnlyBenefit => this.hasMetadata(metadataCampaignInviteOnly, privateSaleBenefit);

  bool get hasPrivateSaleBenefit => this.benefitWith(privateSaleBenefit) != null;

  bool get hasVIPPrivateSaleBenefit => benefitWith(vipPrivateSaleBenefit) != null;

  bool get hasRestrictedBrandsBenefit => benefitWith(restrictedBrandsBenefit) != null;

  bool get hasPrivateClientBenefit => benefitWith(privateClientBenefit) != null;

  BenefitModel benefitWith(String name) {
    List<BenefitModel> arr = this.benefits.map((benefit) => (benefit.code != null && benefit.isActive && benefit.code.toLowerCase() == name.toLowerCase()) ? benefit : null).toList();

    if (arr.length > 0) {
      return arr.first;
    } else {
      return null;
    }
  }

  bool hasMetadata(String metadata, String benefitName) {
    BenefitModel benefit = this.benefitWith(benefitName);
    if (benefit == null || benefit.metadata == null) {
      return false;
    } else {
      String val = benefit.metadata[metadataCampaignCode] as String;
      return val.toLowerCase() == metadata.toLowerCase();
    }
  }

  ////////////////////////////////////////////////////////////////////////////

  UserTier get tier {
    List<BenefitModel> activeBenefits = this.benefits.where((benefit) => benefit.isActive).toList();

    List<UserTier> validTiers = List<UserTier>();
    for (final benefit in activeBenefits) {
      UserTier tier = this._tierFor(benefit.code);
      if (tier != UserTier.none) {
        validTiers.add(tier);
      }
    }

    validTiers.sort((tier1, tier2) => tier1.index - tier2.index);
    return validTiers.first ?? UserTier.none;
  }

  static String tierNameFor(UserTier value) {
    String result;
    UserModel._benefitNamesPerTiers.forEach((key, tier) {
      if (tier == value && result != null) {
        result = key;
      }
    });

    return result;
  }

  static const Map<String, UserTier> _benefitNamesPerTiers = {
    "bronze-access": UserTier.bronze,
    "silver-access": UserTier.silver,
    "gold-access": UserTier.gold,
    "platinum-access": UserTier.platinum,
    "private-client-access": UserTier.privateClient,
  };

  UserTier _tierFor(String benefitName) {
    if (benefitName == null || benefitName.length == 0) {
      return UserTier.none;
    } else {
      return UserModel._benefitNamesPerTiers[benefitName] ?? UserTier.none;
    }
  }

////////////////////////////////////////////////////////////////////////////

  List<BenefitModel> saleLandingBenefitMapOnContentApiRetrieval() {
    if (this.hasVIPPrivateSaleBenefit) {
      BenefitModel benefit = this._composeBenefitModelFor(UserTier.privateClient);
      if (benefit != null) {
        return [benefit];
      }
    }

    if (this.hasPrivateSaleBenefit) {
      BenefitModel benefit = this._composeBenefitModelFor(UserTier.silver);
      if (benefit != null) {
        return [benefit];
      }
    }
    return [];
  }

  BenefitModel _composeBenefitModelFor(UserTier tier) {
    String accessCode = UserModel.tierNameFor(tier);
    if (accessCode == null || accessCode.length == 0) {
      return null;
    }

    return BenefitModel(id: accessCode, code: accessCode, isActive: true, metadata: Map<String, dynamic>());
  }
}
