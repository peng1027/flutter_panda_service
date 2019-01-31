/*
 *
 * key_value_store_user.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/7/19 5:05 PM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import '../business_service/user/user_model.dart';

import 'identifiable_protocol.dart';

class KeyValueStoreUser extends KeyValueStore implements Identifiable {
  static String get _keyGuestID => "FFKGuestUserId";
  static String get _keyUserInfo => "IdentifiableUserInfo";

  @override
  String get bagID => userInfo == null ? null : userInfo.bagId;

  @override
  int get guestID {
    if (userInfo == null) return this[_keyGuestID];
    return userInfo.userType == UserType.guest ? userInfo.id : null;
  }

  @override
  int get personalShopperID => userInfo == null ? null : userInfo.personalShopperId;

  @override
  int get userID {
    if (userInfo == null) return null;
    return userInfo.userType == UserType.guest ? null : userInfo.id;
  }

  @override
  String get wishListID => userInfo == null ? null : userInfo.wishlistId;

  @override
  UserModel get userInfo => this[_keyUserInfo];

  @override
  set userInfo(UserModel newUserInfo) => this[_keyUserInfo] = newUserInfo;
}