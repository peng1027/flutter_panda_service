/*
 * authentication_help.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/16/19 3:31 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'auth_token.dart';
import 'authentication.dart';

mixin AuthenticationHelper implements Authentication {
  
  Future<AuthToken> futureForRequestTokenIfNeeded(bool needAuth) async {
    return Future(() async {
      if (needAuth == false) return null;
      await this.requestTokenIfNeeded((token, _, error) {
        if (error != null) return null;
        else return token;
      });
    });
  }
}
