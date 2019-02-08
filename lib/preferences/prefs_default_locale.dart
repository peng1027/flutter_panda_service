/*
 * prefs_default_locale.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

class PrefsDefaultLocale extends EnumValue<String> {
  const PrefsDefaultLocale(String value) : super(value);

  static const PrefsDefaultLocale countryCode = const PrefsDefaultLocale("CN");
  static const PrefsDefaultLocale countryName = const PrefsDefaultLocale("中国内地");
  static const PrefsDefaultLocale countryCulture = const PrefsDefaultLocale("zh-CN");
  static const PrefsDefaultLocale currencyCode = const PrefsDefaultLocale("CNY");
  static const PrefsDefaultLocale currencyCulture = const PrefsDefaultLocale("zh-CN");
  static const PrefsDefaultLocale languageCode = const PrefsDefaultLocale("zh-CN");
}

class PrefsKey extends EnumValue<String> {
  const PrefsKey(String value) : super(value);

  static const PrefsKey countryID = const PrefsKey("JurisdictionCountryId");
  static const PrefsKey countryCode = const PrefsKey("JurisdictionCountryCode");
  static const PrefsKey countryName = const PrefsKey("JurisdictionCountryName");
  static const PrefsKey countryCulture = const PrefsKey("JurisdictionCountryCulture");
  static const PrefsKey currencyCode = const PrefsKey("JurisdictionCurrencyCode");
  static const PrefsKey currencyCulture = const PrefsKey("JurisdictionCurrencyCulture");
  static const PrefsKey languageCode = const PrefsKey("JurisdictionLanguage");
  static const PrefsKey taxDutiesSetting = const PrefsKey("JurisdictionTaxDutiesSetting");
}
