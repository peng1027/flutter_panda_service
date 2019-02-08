/*
 * identifiable_protocol.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import '../business_service/user/user_model.dart';

abstract class Identifiable {
  int get userID;
  int get guestID;
  String get bagID;
  String get wishListID;
  int get personalShopperID;

  UserModel get userInfo;
  set userInfo(UserModel newUserInfo);
}
