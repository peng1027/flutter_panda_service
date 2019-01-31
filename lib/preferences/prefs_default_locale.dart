/*
 * prefs_default_locale.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/1/19 4:31 AM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

class PrefsDefaultLocale extends EnumValue<String> {
  PrefsDefaultLocale(String value) : super(rawValue: value);

  factory PrefsDefaultLocale.countryCode() => PrefsDefaultLocale("CN");
  factory PrefsDefaultLocale.countryName() => PrefsDefaultLocale("中国内地");
  factory PrefsDefaultLocale.countryCulture() => PrefsDefaultLocale("zh-CN");
  factory PrefsDefaultLocale.currencyCode() => PrefsDefaultLocale("CNY");
  factory PrefsDefaultLocale.currencyCulture() => PrefsDefaultLocale("zh-CN");
  factory PrefsDefaultLocale.languageCode() => PrefsDefaultLocale("zh-CN");
}

class PrefsKey extends EnumValue<String> {
  PrefsKey(String value) : super(rawValue: value);

  factory PrefsKey.countryID() => PrefsKey("JurisdictionCountryId");
  factory PrefsKey.countryCode() => PrefsKey("JurisdictionCountryCode");
  factory PrefsKey.countryName() => PrefsKey("JurisdictionCountryName");
  factory PrefsKey.countryCulture() => PrefsKey("JurisdictionCountryCulture");
  factory PrefsKey.currencyCode() => PrefsKey("JurisdictionCurrencyCode");
  factory PrefsKey.currencyCulture() => PrefsKey("JurisdictionCurrencyCulture");
  factory PrefsKey.languageCode() => PrefsKey("JurisdictionLanguage");
  factory PrefsKey.taxDutiesSetting() => PrefsKey("JurisdictionTaxDutiesSetting");
}
