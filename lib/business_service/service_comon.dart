/*
 * service_comon.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import '../restful_service/response.dart';

typedef ServiceCompletion(Response response, ErrorType error);
typedef ServiceEntityCompletion<T>(T data, Response response, ErrorType error);
