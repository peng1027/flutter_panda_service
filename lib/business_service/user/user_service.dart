/*
 * user_service.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'benefit_model.dart';
import 'request_user_model.dart';
import 'user_model.dart';

import 'package:flutter_panda_service/restful_service/service_result.dart';
import '../../restful_service/service_provider.dart';

// UserService the API service about user data
abstract class UserService extends ServiceProvider {
  createUser(RequestUserModel requestBody, ServiceEntityCompletion<UserModel> complete) {}
  update(UserModel entity, ServiceCompletion complete) {}
  fetchMe(ServiceEntityCompletion<UserModel> completion) {}

  createGuest(RequestGuestModel requestBody, ServiceEntityCompletion<UserModel> completion) {}
  fetchGuest(int guestID, ServiceEntityCompletion<UserModel> completion) {}

  fetchBenefits(int userID, bool isGuest, ServiceEntityCompletion<List<BenefitModel>> completion) {}
  changePassword(int userID, String username, String oldPassword, String newPassword, ServiceCompletion completion) {}
}

// UserServiceImmpl the implementation of `UserService`
class UserServiceImmpl implements UserService {
  @override
  createUser(RequestUserModel requestBody, ServiceEntityCompletion<UserModel> complete) {
    // TODO: implement createUser
    return null;
  }

  @override
  update(UserModel entity, ServiceCompletion complete) {
    // TODO: implement update
    return null;
  }

  @override
  fetchMe(ServiceEntityCompletion<UserModel> completion) {
    // TODO: implement fetchMe
    return null;
  }

  @override
  changePassword(int userID, String username, String oldPassword, String newPassword, ServiceCompletion completion) {
    // TODO: implement changePassword
    return null;
  }

  @override
  createGuest(RequestGuestModel requestBody, ServiceEntityCompletion<UserModel> completion) {
    // TODO: implement createGuest
    return null;
  }

  @override
  fetchBenefits(int userID, bool isGuest, ServiceEntityCompletion<List<BenefitModel>> completion) {
    // TODO: implement fetchBenefits
    return null;
  }

  @override
  fetchGuest(int guestID, ServiceEntityCompletion<UserModel> completion) {
    // TODO: implement fetchGuest
    return null;
  }
}
