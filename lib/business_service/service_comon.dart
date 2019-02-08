/*
 * service_comon.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/8/19 1:49 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import '../restful_service/response.dart';

typedef ServiceCompletion(Response response, Error error);
typedef ServiceEntityCompletion<T>(T data, Response response, Error error);
