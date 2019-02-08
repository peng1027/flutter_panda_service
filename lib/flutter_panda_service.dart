/*
 * flutter_panda_service.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

library flutter_panda_service;

export 'account_manager/AccountManager.dart';
export 'account_manager/AccountManagerProtocol.dart';

export 'business_service/user/user_model.dart';
export 'business_service/user/benefit_model.dart';
export 'business_service/user/request_user_model.dart';
export 'business_service/user/user_service.dart';

export 'restful_service/endpoints.dart';
export 'restful_service/service_provider.dart';

bool debugModel = false;

void enableDebug() {
  debugModel = true;
}
