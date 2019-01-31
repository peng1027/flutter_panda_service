/*
 * preferences.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/1/19 4:26 AM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'package:flutter_panda_service/preferences/prefs_default_locale.dart';
import 'prefs_jurisdiction.dart';

class Preferences extends KeyValueStore implements JurisdictionProtocol {
  factory Preferences() => _getInstance();
  static Preferences get instance => _getInstance();
  static Preferences _instance;

  Preferences._internal();

  static Preferences _getInstance() {
    if (_instance == null) {
      _instance = new Preferences._internal();
    }
    return _instance;
  }

  ////////////////////////////////////////////////////////////////////////

  String countryCode() => this[PrefsKey.countryCode().rawValue] ?? PrefsDefaultLocale.countryCode();
  setCountryCode(String countryCode) => this[PrefsKey.countryCode().rawValue] = countryCode;

  String countryCulture() => this[PrefsKey.countryCulture().rawValue] ?? PrefsDefaultLocale.countryCulture();
  setCountryCulture(String countryCulture) => this[PrefsKey.countryCulture().rawValue] = countryCulture;

  int countryID() => this[PrefsKey.countryID().rawValue] ?? null;
  setCountryID(int countryID) => this[PrefsKey.countryID().rawValue] = countryID;

  String countryName() => this[PrefsKey.countryName().rawValue] ?? PrefsDefaultLocale.countryName();
  setCountryName(String countryName) => this[PrefsKey.countryName().rawValue] = countryName;

  String currencyCode() => this[PrefsKey.currencyCode().rawValue] ?? PrefsDefaultLocale.currencyCode();
  setCurrencyCode(String currencyCode) => this[PrefsKey.currencyCode().rawValue] = currencyCode;

  String currencyCulture() => this[PrefsKey.currencyCulture().rawValue] ?? PrefsDefaultLocale.currencyCulture();
  setCurrencyCulture(String currencyCulture) => this[PrefsKey.currencyCulture().rawValue] = currencyCulture;

  String languageCode() => this[PrefsKey.languageCode().rawValue] ?? PrefsDefaultLocale.languageCode();
  setLanguageCode(String languageCode) => this[PrefsKey.languageCode().rawValue] = languageCode;

  TaxDutiesSetting taxDutiesSetting() => this[PrefsKey.taxDutiesSetting().rawValue] ?? TaxDutiesSetting();
  setTaxDutiesSetting(TaxDutiesSetting taxDutiesSetting) => this[PrefsKey.taxDutiesSetting().rawValue] = taxDutiesSetting.rawValue;

  void updateLocaleHeaders(LocaleHeader locale) {
    setCountryCode(locale.country);
    setCurrencyCode(locale.currency);
    setLanguageCode(locale.language);
  }
}
