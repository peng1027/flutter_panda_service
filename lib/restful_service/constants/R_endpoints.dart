/*
 * R_endpoints.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/14/19 4:14 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import '../endpoints.dart';

class EndpointCollection {
  // authentication
  static Endpoint get tokenRequest => Endpoint(apiType: ApiType.authentication, apiPath: "connect/token");
  static Endpoint get tokenRevoke => Endpoint(apiType: ApiType.authentication, apiPath: "connect/revocation");

  // mobile
  static Endpoint get mobileSecurityCode => Endpoint(apiType: ApiType.channelService, apiPath: "api/v1/identities/mobile/security-code");
  static Endpoint get mobileVerification => Endpoint(apiType: ApiType.channelService, apiPath: "api/v1/identities/mobile/security-code/verification");

  // user
  static Endpoint get guestCreate => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/guestUsers");
  static Endpoint get guestFetchByID => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/guestUsers/%d");
  static Endpoint get guestBenefitsFetch => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/guestUsers/%d/benefits");
  static Endpoint get userCreate => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/users");
  static Endpoint get userUpdate => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/users/%d");
  static Endpoint get userFetchByID => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/users/%d");
  static Endpoint get userFetchMe => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/users/me");
  static Endpoint get userBenefitsFetch => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/users/%d/benefits");
  static Endpoint get userPersonalShopperFetchByID => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/personalShoppers/%d");
  static Endpoint get userPasswordChange => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/users/%d/password-change");

  // CountryProperty
  static Endpoint get countryProperties => Endpoint(apiType: ApiType.channelService, apiPath: "api/v1/contents/country-properties");

  static Endpoint get bwContent => Endpoint(apiType: ApiType.channelService, apiPath: "api/v0/content/v1/search/contents");

  // Marketing
  static Endpoint get signActivate => Endpoint(apiType: ApiType.marketing, apiPath: "api/v0/marketing/v1/campaigns/%@/activations");
  static Endpoint get subscriptionPackages => Endpoint(apiType: ApiType.marketing, apiPath: "api/v0/marketing/v1/subscriptionPackages");
  static Endpoint get subscribe => Endpoint(apiType: ApiType.marketing, apiPath: "api/v0/marketing/v1/subscriptions");
  static Endpoint get trackWeChatShare => Endpoint(apiType: ApiType.marketing, apiPath: "api/v1/marketing/trackings/wechat-sharing");
  static Endpoint get track => Endpoint(apiType: ApiType.marketing, apiPath: "api/v0/marketing/v1/trackings");

  // Tenant
  static Endpoint get tenantMe => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/tenants/me");
  static Endpoint get tenantOptions => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/tenants/%d/options");

  // ShoppingBag
  static Endpoint get bagMerge => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/bags/%@/merge/%@");

  // Wishlist
  static Endpoint get wishlistMerge => Endpoint(apiType: ApiType.eCommerce, apiPath: "v1/wishlists/%@/merge/%@");
}
