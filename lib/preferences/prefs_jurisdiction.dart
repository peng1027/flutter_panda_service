/*
 * prefs_jurisdiction.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/1/19 4:35 AM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

class LocaleHeader {
  final String country;
  final String currency;
  final String language;

  LocaleHeader({this.country, this.currency, this.language});
}

class TaxDutiesSetting extends EnumValue<String> {
  static const String deliveredAtPlace = "Dap";
  static const String deliveredDutyPaid = "Ddp";

  TaxDutiesSetting([String type]) : super(rawValue: type);

  factory TaxDutiesSetting.getDeliveredAtPlace() => TaxDutiesSetting(TaxDutiesSetting.deliveredAtPlace);
  factory TaxDutiesSetting.getDeliveredDutyPaid() => TaxDutiesSetting(TaxDutiesSetting.deliveredDutyPaid);

  int intValue() {
    if (this.rawValue == deliveredAtPlace) {
      return 1;
    } else if (this.rawValue == deliveredDutyPaid) {
      return 2;
    } else {
      assert(false, "** error: invalie `TaxDutiesSetting` type ${this.rawValue}.");
      return -1;
    }
  }

  ///TODO: continue here. this class is not finished yet.
}

abstract class JurisdictionProtocol {
  int countryID();
  void setCountryID(int newValue);

  String countryCode();
  void setCountryCode(String newValue);

  String countryName();
  void setCountryName(String newValue);

  String countryCulture();
  void setCountryCulture(String newValue);

  String currencyCode();
  void setCurrencyCode(String newValue);

  String currencyCulture();
  void setCurrencyCulture(String newValue);

  String languageCode();
  void setLanguageCode(String newValue);

  TaxDutiesSetting taxDutiesSetting();
  void setTaxDutiesSetting(TaxDutiesSetting newValue);

  void updateLocaleHeaders(LocaleHeader locale);
}
