import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(nullable: false)
class UserModel {
  static const String NotDefined = "NotDefined";
  static const String Male = "Male";
  static const String Female = "Female";

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

  UserModel(
      {@required this.id,
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
      this.expiryDate});
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  List<BenefitModel> benefits = List<BenefitModel>();

  isGuest() => username.isEmpty;

  firstName() {
    List<String> names = this.name.split(" ");
    return names.first ?? "";
  }

  lastName() {
    List<String> names = name.split(" ");
    return names.length > 1 ? names.last : "";
  }
}

@JsonSerializable(nullable: false)
class BenefitModel {
  final String id;
  final String code;
  final bool isActive;
  final Map<String, dynamic> metadata;

  BenefitModel({@required this.id, this.code, this.isActive, this.metadata});

  factory BenefitModel.fromJson(Map<String, dynamic> json) =>
      _$BenefitModelFromJson(json);
  Map<String, dynamic> toJson() => _$BenefitModelToJson(this);
}
